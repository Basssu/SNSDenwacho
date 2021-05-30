//
//  MyQRCodeViewController.swift
//  SNSDenwacho
//
//  Created by Yuma Ishibashi on 2021/05/30.
//

import UIKit

class MyQRCodeViewController: UIViewController {
    
    @IBOutlet var myQRImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlText = "https://kikuragechan.com"
        let image = makeQRCode(text: urlText)
        self.myQRImageView.image = image
        // Do any additional setup after loading the view.
    }
    
    func makeQRCode(text: String) -> UIImage? {
        guard let data = text.data(using: .utf8) else { return nil }
        guard let QR = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": data]) else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        guard let ciImage = QR.outputImage?.transformed(by: transform) else { return nil }
        guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
