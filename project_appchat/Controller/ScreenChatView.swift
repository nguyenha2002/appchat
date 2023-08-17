//
//  ScreenChatView.swift
//  project_appchat
//
//  Created by Nguyễn Thị Hạ on 29/07/2023.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import IQKeyboardManagerSwift


class ScreenChatView: UIViewController {
    var tableName: DatabaseReference!
    var arridChat: [String] = []
    var arrtxtChat: [String] = []
    var arruserChat: [User] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfContent: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        // Do any additional setup after loading the view.
        arridChat.append(currentUser.id)
        arridChat.append((vistor?.id)!)
        arridChat.sort()
        let key: String = "\(arridChat[0])\(arridChat[1])"
        tableName = ref.child("Chat").child(key)
        
        tableName.observe(.childAdded, with: { snapshot in

            let postDict = snapshot.value as? [String: AnyObject]
            if postDict != nil {
                if (postDict?["id"]) as? String == currentUser.id{
                    self.arruserChat.append(currentUser)
                }else {
                    self.arruserChat.append(vistor!)
                }
                self.arrtxtChat.append(postDict?["message"] as! String)
                self.tableView.reloadData()
            }
        })
    }
    
    @IBAction func btnSend(_ sender: Any) {
        let mess: Dictionary<String, String> = ["id": currentUser.id, "message": tfContent.text!]
        tableName.childByAutoId().setValue(mess)
        tfContent.text = ""
        if arrtxtChat.count == 0 {
            addListChat(user1: currentUser, user2: vistor!)
            addListChat(user1: vistor!, user2: currentUser)
        }
    }
    func addListChat(user1: User, user2: User){
        let tableName2 = ref.child("ListChat").child(user1.id).child((user2.id)!)
        let user: Dictionary<String, String> = ["email": user2.email as? String ?? "", "fullname": user2.fullname as? String ?? "", "linkAvatar": user2.linkAvatar as? String ?? ""]
        tableName2.setValue(user)
    }
    func setupTable(){
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "CellReceiver", bundle: nil)
        let lib = UINib(nibName: "CellSender", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "cellReceiver")
        tableView.register(lib, forCellReuseIdentifier: "cellSender")
    }
    

}
extension ScreenChatView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrtxtChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentUser.id == arruserChat[indexPath.row].id {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellSender", for: indexPath) as! CellSender
            cell.lbContentSender.text = arrtxtChat[indexPath.row]
            cell.imgSend.image = currentUser.Avatar
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellReceiver", for: indexPath) as! CellReceiver
            cell.lbContentReceiver.text = arrtxtChat[indexPath.row]
            cell.imgReceiver.image = vistor?.Avatar
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
