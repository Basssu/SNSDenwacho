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
//    let im: UIImage? = nil
    var d: Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.delegate = self
        nameLabel.delegate = self
        passWordLabel.delegate = self
        passWordLabel2.delegate = self
        twitterLabel.delegate = self
        facebookLabel.delegate = self
        instagramLabel.delegate = self
    }
    
    override func viewDidAppear(_ animated:Bool) {
        if(userDefaults.string(forKey: "currentUser") != nil){
            self.performSegue(withIdentifier: "toFriendListFromCreatePage", sender: nil)
        }
    }
    
    @IBAction func setProfileImageButton() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)

    }
    
    @IBAction func createAccountbutton() {
        guard self.userNameLabel.text!.count >= 7 && self.passWordLabel.text!.count >= 7 && self.passWordLabel.text! == self.passWordLabel2.text! else {
            let alert = UIAlertController(title: "入力情報の不備", message: "ユーザーネームとパスワードは7文字以上を入力してください。", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let ref = Storage.storage().reference().child("/users/\(userNameLabel.text!)/profileImage.jpg")
        if (self.d != nil){
            let md = StorageMetadata()
            md.contentType = "image/png"
            ref.putData(self.d!, metadata: md) { (metadata, error) in
                if error == nil {
                    ref.downloadURL(completion: { (url, error) in
                        print("Done, url is \(String(describing: url))")
                        self.sendUserDataToFieebase(url: String(describing: url))
                    })
                }else{
                    return
                }
            }
            
        }else{
            self.sendUserDataToFieebase(url: "")
        }
    }
    
    func sendUserDataToFieebase(url:String){
        self.db.collection("users").document(self.userNameLabel.text!).setData([
            "friends":[],
            "image_url":url,
            "name": self.nameLabel.text!,
            "password": self.passWordLabel.text!,
            "sns_facebook": self.facebookLabel.text!,
            "sns_instagram": self.instagramLabel.text!,
            "sns_twitter":self.twitterLabel.text!,
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                
                self.userDefaults.set(self.userNameLabel.text!, forKey: "currentUser")
                self.performSegue(withIdentifier: "toFriendListFromCreatePage", sender: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let im: UIImage = info[.editedImage] as? UIImage else { return }
    self.d = im.jpegData(compressionQuality: 0.5)
     self.profileImageView.image = im
     

     

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

