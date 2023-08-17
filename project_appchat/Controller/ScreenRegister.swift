//
//  ScreenRegister.swift
//  project_appchat
//
//  Created by Nguyễn Thị Hạ on 28/07/2023.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import IQKeyboardManagerSwift

let storage = Storage.storage()
let storageRef = storage.reference(forURL: "gs://project-appchat-52033.appspot.com")
var choosAvatar: Data!

class ScreenRegister: ViewController {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var txtfullName: UITextField!
    @IBOutlet weak var txtRepassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbRegister: UILabel!
    
    let imgPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundCorner(views: [btnRegister, btnLogin], radius: 20)
        setupImg()
    }
    
    @IBAction func tapOnRegister(_ sender: Any) {
        view.endEditing(true)
        startAnimating()
        
        if txtEmail.text == "" {
            view.self.makeToast("Please enter your email")
            stopAnimating()
            return
        }
        if txtPassword.text == "" {
            view.self.makeToast("Please enter your password")
            stopAnimating()
            return
        }
        if txtRepassword.text == "" {
            view.self.makeToast("Please enter your Re-password")
            stopAnimating()
            return
        }
        if txtfullName.text == "" {
            view.self.makeToast("Please enter your Fullname")
            stopAnimating()
            return
        }
        Auth.auth().createUser(withEmail: self.txtEmail.text!, password: self.txtPassword.text!) { [self]
           result, error in
            if error == nil {
                Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) {
                    authResult, error in
                    if error == nil
                    {
                        let sb = UIStoryboard(name: "Main", bundle: nil)
                        let vc = sb.instantiateViewController(identifier: "tabbar")
                        vc.modalPresentationStyle = .fullScreen
                        navigationController?.pushViewController(vc, animated: true)
                        txtEmail.text = ""
                        txtPassword.text = ""
                        txtfullName.text = ""
                        txtRepassword.text = ""
                        stopAnimating()
                    }
                    else{
                        view.makeToast(error?.localizedDescription)
                        stopAnimating()
                    }
                }
                let avatarRef = storageRef.child("images/\(txtEmail.text).jpg")
                let uploadTask = avatarRef.putData(choosAvatar, metadata: nil) { (metadata, error) in
                    guard let metadata = metadata else { return  }
                    if error != nil
                    {
                        view.makeToast(error?.localizedDescription)
                        stopAnimating()
                    }
                    else
                    {
                        let size = metadata.size
                        avatarRef.downloadURL { (url, error) in
                            guard let downloadURL = url else {return}
                            if error != nil {
                                self.view.makeToast(error?.localizedDescription)
                                self.stopAnimating()
                            }
                            else{
                                let user = Auth.auth().currentUser
                                if let user = user {
                                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                    changeRequest?.displayName = self.txtfullName.text!
                                    changeRequest?.photoURL = url
                                    
                                    changeRequest?.commitChanges { error in
                                        if error == nil
                                        {
                                            let sb = UIStoryboard(name: "Main", bundle: nil)
                                            let vc = sb.instantiateViewController(identifier: "tabbar")
                                            vc.modalPresentationStyle = .fullScreen
                                            navigationController?.pushViewController(vc, animated: true)
                                            self.stopAnimating()
                                            imgAvatar.image = UIImage(named: "image_placeholder")
                                            txtEmail.text = ""
                                            txtPassword.text = ""
                                            txtfullName.text = ""
                                            txtRepassword.text = ""
                                        }
                                        else
                                        {
                                            self.view.makeToast(error?.localizedDescription)
                                            stopAnimating()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
                uploadTask.resume()
            }
            else
            {
                view.makeToast(error?.localizedDescription)
                stopAnimating()
            }
        }
        
        
        
    }
    
    @IBAction func tapOnLogin(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "login")
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupImg(){
        roundCorner(views: [imgAvatar], radius: 86)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imgAvatar.addGestureRecognizer(tapGes)
    }
    @objc func chooseImage(){
       let alert = UIAlertController(title: "Choose your avatar", message: nil, preferredStyle: .actionSheet)
               let action = UIAlertAction(title: "Photo Library", style: .default) { action in
                   self.imgPicker.sourceType = .photoLibrary
                   self.imgPicker.delegate = self
                   self.present(self.imgPicker, animated: true)
               }
               let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
               alert.addAction(action)
               alert.addAction(actionCancel)
               present(alert, animated: true)
           }

   }
   extension ScreenRegister: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
               if let chooseImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                   choosAvatar = chooseImage.pngData()
                   imgAvatar.image = UIImage(data: choosAvatar)
                   dismiss(animated: true)
               }
           }
       }
