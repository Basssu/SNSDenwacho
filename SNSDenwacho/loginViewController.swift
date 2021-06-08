//
//  loginViewController.swift
//  SNSDenwacho
//
//  Created by Yuma Ishibashi on 2021/05/30.
//

import UIKit
import Firebase
import FirebaseFirestore

class loginViewController: UIViewController {
    let db = Firestore.firestore()
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapLogInButton() {
        let docRef = db.collection("users").document(userName.text!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if(self.password.text == document.data()!["password"] as? String){
                    self.userDefaults.set(document.documentID, forKey: "currentUser")
                    self.performSegue(withIdentifier: "toFriendListFromLoginPage", sender: nil)
                }else{
                    print("password is not correct")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @IBAction func tapBackButton() {
        self.dismiss(animated: true, completion: nil)
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
