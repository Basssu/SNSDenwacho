//
//  profilePageViewController.swift
//  SNSDenwacho
//
//  Created by Yuma Ishibashi on 2021/05/30.
//

import UIKit
import Firebase
import FirebaseFirestore

class profilePageViewController: UIViewController {
    
    var userName = ""
    let db = Firestore.firestore()
    var twitterUserName = ""
    var instagramUserName = ""
    var facebookUrl = ""
    var isMyProfile = true
    
    @IBOutlet weak var myQRButtonStackView: UIStackView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var navigationbar: UINavigationItem!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var deleteFriendButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(!isMyProfile){
            logoutButton.isHidden = true
            myQRButtonStackView.isHidden = true
            editButton.isHidden = true
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = nil;
        }else{
            deleteFriendButton.isHidden = true
            userName = UserDefaults.standard.string(forKey:"currentUser")!
        }
        navigationbar.title = userName
        let docRef = db.collection("users").document(userName)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{
                self.profileImageView.image = self.getImageByUrl(url: document.data()!["image_url"] as! String)
                self.nameLabel.text = document.data()!["name"] as? String
                self.twitterUserName = document.data()!["sns_twitter"] as! String
                self.instagramUserName = document.data()!["sns_instagram"] as! String
                self.facebookUrl = document.data()!["sns_facebook"] as! String
                if(self.twitterUserName == ""){
                    self.twitterButton.alpha = 0.3
                    self.twitterButton.isEnabled = false
                }
                if(self.instagramUserName == ""){
                    self.instagramButton.alpha = 0.3
                    self.instagramButton.isEnabled = false
                }
                if(self.facebookUrl == ""){
                    self.facebookButton.alpha = 0.3
                    self.facebookButton.isEnabled = false
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @IBAction func tapTwitterButton() {
        openApp(urlString: "https://twitter.com/"+twitterUserName)
    }
    
    @IBAction func tapInstagramButton() {
        openApp(urlString: "https://www.instagram.com/"+instagramUserName)
    }
    
    @IBAction func tapFacebookButton() {
        openApp(urlString: facebookUrl)
    }
    
    func getImageByUrl(url: String) -> UIImage{
        var finalUrl = ""
        if(url == ""){
            finalUrl = "https://firebasestorage.googleapis.com/v0/b/snsdenwacho.appspot.com/o/unknown.jpg?alt=media&token=39e02483-6c3d-4bb5-afb6-e64a148699f6"
        }else{
            finalUrl = url
        }
        let url = URL(string: finalUrl)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }
    
    func openApp(urlString: String) {
        let url = NSURL(string: urlString)
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.open(NSURL(string: "http://instagram.com/")! as URL)
        }
    }
    
    @IBAction func pushEditButton() {
        performSegue(withIdentifier: "toEditPage", sender: nil)
    }
    
    @IBAction func tapDeleteFriendButton() {
        let alert = UIAlertController(title: "友達削除", message: "この友達を友達リストから削除しますか？", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "はい", style: .default, handler: { action in
            self.db.collection("users").document(UserDefaults.standard.string(forKey:"currentUser")!).updateData([
                "friends": FieldValue.arrayRemove([self.userName]),
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    self.navigationController?.popViewController(animated: true)
                    
                    
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "いいえ", style: .cancel, handler: { action in
            //            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func tapLogoutButton() {
        let alert = UIAlertController(title: "ログアウト", message: "ログアウトします。よろしいですか？", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "はい", style: .default, handler: { action in
            UserDefaults.standard.setValue(nil, forKey: "currentUser")
            self.navigationController?.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "いいえ", style: .cancel, handler: { action in
            //            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // segueのIDを確認して特定のsegueのときのみ動作させる
        if segue.identifier == "toEditPage" {
            // 2. 遷移先のViewControllerを取得
            let next = segue.destination as? editProfileInformationViewController
            // 3. １で用意した遷移先の変数に値を渡す
            next?.twitter = self.twitterUserName
            next?.instagram = self.instagramUserName
            next?.facebook = self.facebookUrl
            next?.name = self.nameLabel.text!
        }
    }
}
