//
//  friendIDListViewController.swift
//  SNSDenwacho
//
//  Created by Yuma Ishibashi on 2021/05/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class friendListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let db = Firestore.firestore()
    var friendIDList: Array<String> = []
    var friendInformationList: [Dictionary<String, String>] = []
    var selectedIndexPath = 0
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        friendIDList = []
        friendInformationList = []
//        let semaphore = DispatchSemaphore(value: 0)
        let docRef = db.collection("users").document(UserDefaults.standard.string(forKey:"currentUser")!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{
                self.friendIDList = document.data()!["friends"] as! Array<String>
                for id in self.friendIDList{
        //            let semaphore2 = DispatchSemaphore(value: 0)
                    let docRef = self.db.collection("users").document(id)
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists{
                            self.friendInformationList.append(["name": document.data()!["name"] as! String,"imageUrl": document.data()!["image_url"] as! String])
        //
                            if(self.friendIDList[self.friendIDList.count-1]==id){
                                self.tableView.reloadData()
                            }
                        } else {
                            print("Document does not exist")
        //                    semaphore2.signal()
                            if(self.friendIDList[self.friendIDList.count-1]==id){
                                self.tableView.reloadData()
                            }
                        }
        //                semaphore2.wait()
                    }
                }
//                semaphore.signal()
            } else {
                print("Document does not exist")
//                semaphore.signal()
                
            }
        }
//        semaphore.wait()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendInformationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! friendListViewCell
        cell.profileImage.image = getImageByUrl(url: friendInformationList[indexPath.row]["imageUrl"]!)
        cell.nameLabel.text = friendInformationList[indexPath.row]["name"]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        performSegue(withIdentifier: "toProfilePage", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // segueのIDを確認して特定のsegueのときのみ動作させる
        if segue.identifier == "toProfilePage" {
            // 2. 遷移先のViewControllerを取得
            let next = segue.destination as? profilePageViewController
            // 3. １で用意した遷移先の変数に値を渡す
            next?.isMyProfile = false
            next?.userName = friendIDList[selectedIndexPath]
            
        }
    }
    
    func getImageByUrl(url: String) -> UIImage{
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
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
