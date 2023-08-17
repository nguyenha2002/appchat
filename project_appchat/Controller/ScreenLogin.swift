//
//  ScreenLogin.swift
//  project_appchat
//
//  Created by Nguyễn Thị Hạ on 29/07/2023.
//

import UIKit
import Firebase
import FirebaseAuth
import IQKeyboardManagerSwift


class ScreenLogin: ViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lbRegister: UIButton!
    @IBOutlet weak var lbLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        roundCorner(views: [lbLogin, lbRegister], radius: 20)
       // isLogin()
       
        // Do any additional setup after loading the view.
    }
    
//    func isLogin(){
//        let  handle = Auth.auth().addStateDidChangeListener { auth, user in
//            if let user = user {
//                self.gotoScreen()
//            } else {
//                print("Chưa đăng nhập")
//            }
//        }
//    }
    @IBAction func btnRegister(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "register")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        startAnimating()
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!){
            authResult, error in
            if error == nil {
                self.gotoScreen()
                self.stopAnimating()
                self.txtEmail.text = ""
                self.txtPassword.text = ""
            }
            else
            {
                self.view.makeToast(error?.localizedDescription)
                self.stopAnimating()
            }
        }
    }
    
}
extension ScreenLogin {
    func gotoScreen(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "tabbar")
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
}
