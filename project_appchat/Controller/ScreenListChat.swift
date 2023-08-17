//
//  ScreenListChat.swift
//  project_appchat
//
//  Created by Nguyễn Thị Hạ on 29/07/2023.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import IQKeyboardManagerSwift

var ref = Database.database().reference()
class ScreenListChat: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var arrUserChat:Array<User> = Array<User>()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        // Do any additional setup after loading the view.
        
        if let user = Auth.auth().currentUser {
            let name = user.displayName
            let uid = user.uid
            let email = user.email
            let photoURL = user.photoURL
            
            currentUser = User(id: uid, email: email!, fullname: name ?? "", linkAvatar: photoURL?.absoluteString ?? "")
            let tableName = ref.child("ListFriend")
            let userid = tableName.child(currentUser.id)
            let user: Dictionary<String,String> = ["email": currentUser.email, "fullname": currentUser.fullname, "linkAvatar": currentUser.linkAvatar]
            userid.setValue(user)
            
            let url = URL(string: currentUser.linkAvatar)!
            do{
                let data = try Data(contentsOf: url)
                currentUser.Avatar = UIImage(data: data)
            }catch{
                
            }
            
        } else {
            print("No current user")
        }
        let tableName = ref.child("ListChat").child(currentUser.id)
        tableName.observe(.childAdded, with: { [self] snapshot in

            let postDict = snapshot.value as? [String: AnyObject]
            if postDict != nil {
                let email = postDict?["email"]! as? String
                let fullName = postDict?["fullname"]! as? String
                let linkAvatar = postDict?["linkAvatar"]! as? String
                
                let user = User(id: snapshot.key, email: email!, fullname: fullName!, linkAvatar: linkAvatar!)
                arrUserChat.append(user)
                self.tableView.reloadData()
            }
        })
    }
    
    func setupTable(){
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "ListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "listCell")
    }
}
extension ScreenListChat: UITableViewDelegate,  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! ListCell
        cell.lbName.text = arrUserChat[indexPath.row].fullname
        
        cell.img.loadAvatar(link: arrUserChat[indexPath.row].linkAvatar)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
