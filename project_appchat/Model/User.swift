//
//  User.swift
//  project_appchat
//
//  Created by Nguyễn Thị Hạ on 29/07/2023.
//

import Foundation
import UIKit

struct User {
    let id: String!
    let email: String!
    let fullname: String!
    let linkAvatar: String!
    var Avatar: UIImage!
    
    init(){
        id = ""
        email = ""
        fullname = ""
        linkAvatar = ""
        Avatar = UIImage(named: "image_placeholder")
    }
    init(id: String, email: String, fullname: String, linkAvatar: String){
        self.id = id
        self.email = email
        self.fullname = fullname
        self.linkAvatar = linkAvatar
        self.Avatar = UIImage(named: "image_placeholder")
    }
}
