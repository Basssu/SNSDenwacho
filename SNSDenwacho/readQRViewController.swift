//
//  readQRViewController.swift
//  SNSDenwacho
//
//  Created by Yuma Ishibashi on 2021/05/30.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseFirestore

class readQRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        navigationController?.navigationBar.isTranslucent = false
        
        cameraView.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
            
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(origin: .zero, size: view.bounds.size)
        previewLayer.videoGravity = .resizeAspectFill
        cameraView.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(newFriendUserName: stringValue)
        }
        
        //        navigationController?.popViewController(animated: true)
            }
    
    func found(newFriendUserName: String) {
        let docRef = db.collection("users").document(newFriendUserName)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{
                
                let alert = UIAlertController(title: "友だち追加", message: (document.data()!["name"] as? String)!+"を友だち追加しますか？", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "はい", style: .default, handler: { action in
                    self.db.collection("users").document(UserDefaults.standard.string(forKey:"currentUser")!).updateData([
                        "friends": FieldValue.arrayUnion([newFriendUserName]),
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }

                    self.dismiss(animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "いいえ", style: .cancel, handler: { action in
                    self.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "無効なQRコード", message: "このQRコードは無効です。", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:  { action in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    @IBAction func tapBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
