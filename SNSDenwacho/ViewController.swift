//
//  ViewController.swift
//  SNSDenwacho
//
//  Created by Yuma Ishibashi on 2021/05/21.
//

import UIKit

class ViewController: UIViewController {
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        self.userDefaults.set(nil, forKey: "currentUser")

    }
}

