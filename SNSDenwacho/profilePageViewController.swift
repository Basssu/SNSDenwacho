//
//  profilePageViewController.swift
//  SNSDenwacho
//
//  Created by Yuma Ishibashi on 2021/05/30.
//

import UIKit

class profilePageViewController: UIViewController {
    
    var isMyProfile = true
    
    @IBOutlet weak var myQRButtonStackView: UIStackView!
    @IBOutlet weak var editButton: UIButton!
    
    var profileInformation: Dictionary<String, String> = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!isMyProfile){
            myQRButtonStackView.isHidden = true
            editButton.isHidden = true
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = nil;
            self.title = "友達のプロフィール"
        }
        // Do any additional setup after loading the view.
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
