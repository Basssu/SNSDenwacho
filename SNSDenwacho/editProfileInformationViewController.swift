//
//  editProfileInformationViewController.swift
//  SNSDenwacho
//
//  Created by Yuma Ishibashi on 2021/06/08.
//

import UIKit
import FirebaseFirestore

class editProfileInformationViewController: UIViewController {
    
    let db = Firestore.firestore()
    var twitter = ""
    var instagram = ""
    var facebook = ""
    var name = ""

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var twitterUserName: UITextField!
    @IBOutlet weak var instagramUserName: UITextField!
    @IBOutlet weak var facebookLink: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        twitterUserName.text = twitter
        instagramUserName.text = instagram
        facebookLink.text = facebook
        nameTextField.text = name
        // Do any additional setup after loading the view.
    }
    @IBAction func tapSaveButton(_ sender: Any) {
        self.db.collection("users").document(UserDefaults.standard.string(forKey:"currentUser")!).updateData([
            "name": nameTextField.text!,
            "sns_twitter": twitterUserName.text!,
            "sns_instagram": instagramUserName.text!,
            "sns_facebook": facebookLink.text!
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.navigationController?.popViewController(animated: true)
            }
        }
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
