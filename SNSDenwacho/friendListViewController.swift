//
//  friendListViewController.swift
//  SNSDenwacho
//
//  Created by Yuma Ishibashi on 2021/05/23.
//

import UIKit

class friendListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! friendListViewCell
        cell.nameLabel.text = "a"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        performSegue(withIdentifier: "toProfilePage", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            // segueのIDを確認して特定のsegueのときのみ動作させる
            if segue.identifier == "toProfilePage" {
                // 2. 遷移先のViewControllerを取得
                let next = segue.destination as? profilePageViewController
                // 3. １で用意した遷移先の変数に値を渡す
                next?.isMyProfile = false
                next?.profileInformation = ["twitter": "","instagram":"", "facebook": "", "imageUrl":""]

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
