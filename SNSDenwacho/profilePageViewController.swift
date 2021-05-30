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
    var imageUrl = ""
    var twitterUserName = ""
    var instagramUserName = ""
    var facebookUrl = ""
    var isMyProfile = true

    @IBOutlet weak var myQRButtonStackView: UIStackView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!isMyProfile){
            myQRButtonStackView.isHidden = true
            editButton.isHidden = true
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = nil;
            self.title = "友達のプロフィール"
        }else{
            userName = UserDefaults.standard.string(forKey:"currentUser")!
        }
        let docRef = db.collection("users").document(userName)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{
                self.nameLabel.text = document.data()!["name"] as? String
                self.imageUrl = document.data()!["image_url"] as! String
                self.twitterUserName = document.data()!["sns_twitter"] as! String
                self.instagramUserName = document.data()!["sns_instagram"] as! String
                self.facebookUrl = document.data()!["sns_facebook"] as! String
//                self.loadView()
//                self.viewDidLoad()
            } else {
                print("Document does not exist")
            }
        }
        // Do any additional setup after loading the view.
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
    
    func openApp(urlString: String) {
        let url = NSURL(string: urlString)
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL)
        } else {
          //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.open(NSURL(string: "http://instagram.com/")! as URL)
        }
    }
    
}
