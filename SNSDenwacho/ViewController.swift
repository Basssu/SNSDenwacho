//
//  ViewController.swift
//  SNSDenwacho
//
//  Created by Yuma Ishibashi on 2021/05/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var passWordLabel: UITextField!
    @IBOutlet weak var passWordLabel2: UITextField!
    @IBOutlet weak var twitterLabel: UITextField!
    @IBOutlet weak var instagramLabel: UITextField!
    @IBOutlet weak var facebookLabel: UITextField!
    
    let userDefaults = UserDefaults.standard
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // キーボードを閉じる
            textField.resignFirstResponder()
            return true
        }
}

