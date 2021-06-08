//
//  ViewController.swift
//  SNSDenwacho
//
//  Created by Yuma Ishibashi on 2021/05/21.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class ViewController: UIViewController, UITextFieldDelegate ,
                      UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var passWordLabel: UITextField!
    @IBOutlet weak var passWordLabel2: UITextField!
    @IBOutlet weak var twitterLabel: UITextField!
    @IBOutlet weak var instagramLabel: UITextField!
    @IBOutlet weak var facebookLabel: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var isLoading = false
    let userDefaults = UserDefaults.standard
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.delegate = self
        nameLabel.delegate = self
        passWordLabel.delegate = self
        passWordLabel2.delegate = self
        twitterLabel.delegate = self
        facebookLabel.delegate = self
        instagramLabel.delegate = self
        self.userDefaults.set(nil, forKey: "currentUser")
    }
    
    @IBAction func setProfileImageButton() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)

    }
    
    @IBAction func createAccountbutton() {
        
        self.db.collection("users").document(userNameLabel.text!).setData([
            "friends":[],
            "image_url":"",
            "name": nameLabel.text!,
            "password": passWordLabel.text!,
            "sns_facebook": facebookLabel.text!,
            "sns_instagram": instagramLabel.text!,
            "sns_twitter":twitterLabel.text!,
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

     guard let im: UIImage = info[.editedImage] as? UIImage else { return }
     guard let d: Data = im.jpegData(compressionQuality: 0.5) else { return }
        
     self.profileImageView.image = im
     let md = StorageMetadata()
     md.contentType = "image/png"

     let ref = Storage.storage().reference().child("someFolder/12345678.jpg")

     ref.putData(d, metadata: md) { (metadata, error) in
         if error == nil {
             ref.downloadURL(completion: { (url, error) in
                 print("Done, url is \(String(describing: url))")
             })
         }else{
             print("error \(String(describing: error))")
         }
     }

     dismiss(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // キーボードを閉じる
            textField.resignFirstResponder()
            return true
        }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField.tag != 1){
            return true
        }
        if string.count > 0 {
            var allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz1234567890_") // 入力可能な文字
            allowedCharacters.insert(charactersIn: " -") // "white space & hyphen"

            let unwantedStr = string.trimmingCharacters(in: allowedCharacters) // 入力可能な文字を全て取り去った文字列に文字があれば、テキスト変更できないFalseを返す。
            if unwantedStr.count == 0 {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
}

