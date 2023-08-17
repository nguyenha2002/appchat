//
//  ViewController.swift
//  project_appchat
//
//  Created by Nguyễn Thị Hạ on 28/07/2023.
//

import UIKit
import NVActivityIndicatorView
import Toast_Swift
import IQKeyboardManagerSwift

class ViewController: UIViewController {
    let viewIndicator = UIView()
    var loadingIndicator: NVActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicator()
        // Do any additional setup after loading the view.
    }
    func setupIndicator(){
          viewIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.6)
          roundCorner(views: [viewIndicator], radius: 10)
          view.addSubview(viewIndicator)
          viewIndicator.translatesAutoresizingMaskIntoConstraints = false
          viewIndicator.widthAnchor.constraint(equalToConstant: 60).isActive = true
          viewIndicator.heightAnchor.constraint(equalToConstant: 60).isActive = true
          viewIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
          viewIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
          viewIndicator.isHidden = true
          
          let frame = CGRect(x: 15, y: 15, width: 30, height: 30)
          loadingIndicator = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.lineScale, color: .white, padding: 0)
          viewIndicator.addSubview(loadingIndicator!)
      }
      func startAnimating(){
          viewIndicator.isHidden = false
          view.isUserInteractionEnabled = false
          loadingIndicator?.stopAnimating()
      }
      func stopAnimating(){
          viewIndicator.isHidden = true
          view.isUserInteractionEnabled = true
          loadingIndicator?.stopAnimating()
      }
      func roundCorner(views: [UIView], radius: CGFloat){
          views.forEach { v in
              v.layer.cornerRadius = radius
              v.layer.masksToBounds = true
          }
          
      }

  }

