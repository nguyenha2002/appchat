//
//  ScreenListFriend.swift
//  project_appchat
//
//  Created by Nguyễn Thị Hạ on 29/07/2023.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import IQKeyboardManagerSwift

var vistor: User?
var currentUser: User!

class ScreenListFriend: UIViewController {
    var listFriend: Array<User> = Array<User>()
    @IBOutlet weak var tableView: UITableView!
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
            if let url = URL(string: currentUser.linkAvatar) {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        // Handle the error
                        print("Error loading image: \(error)")
                    } else if let data = data {
                        // Process the downloaded data
                        DispatchQueue.main.async {
                            currentUser.Avatar = UIImage(data: data)
                            // Update your UI with the downloaded image
                        }
                    }
                }
                task.resume()
            }
            tableName.observe(.childAdded, with: { snapshot in
 
                let postDict = snapshot.value as? [String: AnyObject]
                if postDict != nil {
                    let email = postDict?["email"]! as? String
                    let fullName = postDict?["fullname"]! as? String
                    let linkAvatar = postDict?["linkAvatar"]! as? String
                    
                    let user = User(id: snapshot.key, email: email!, fullname: fullName!, linkAvatar: linkAvatar!)
                    if user.id != currentUser.id {
                        self.listFriend.append(user)
                    }
                    self.tableView.reloadData()
                }
            })
            
        }
        else{
            print("khong co user")
        }
    }
    func setupTable(){
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "ListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "listCell")
    }
    
}
extension ScreenListFriend: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFriend.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as? ListCell
        let data = listFriend[indexPath.row]
        cell?.img.loadAvatar(link: data.linkAvatar)
        cell?.lbName.text = data.fullname
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vistor = listFriend[indexPath.row]
        
        guard let url = URL(string: (vistor?.linkAvatar)!) else { return  }
        do{
            let data = try Data(contentsOf: url)
            vistor?.Avatar = UIImage(data: data)
        }catch{
            
        }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "chatView")
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension UIImageView {
    func loadAvatar(link: String) {
        let queue: DispatchQueue = DispatchQueue(label: "loadImages", attributes: DispatchQueue.Attributes.concurrent, target: nil)
        queue.async {
            let url = URL(string: link)!
            do{
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }catch{
                
            }
        }
    }
}
