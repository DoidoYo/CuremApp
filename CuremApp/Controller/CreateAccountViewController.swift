//
//  CreateAccountViewController.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/24/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    @IBAction func createUserButton(_ sender: Any) {
        let createModel = CreateUserModel()
        createModel.email = emailTextField.text
        createModel.password = passwordTextField.text
        createModel.confirm_password = passwordConfirmTextField.text
        
        FirebaseHelper.create(user: createModel, completion: {
            (error) in
            
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
                self.showDetailViewController(vc!, sender: self)
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textView.layer.cornerRadius = 3;
        textView.layer.masksToBounds = true;
        
        //textfield look
        let border = CALayer()
        let width = CGFloat(1)
        border.borderColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0).cgColor
        border.frame = CGRect(x: 0, y: emailTextField.frame.size.height - width, width:  textView.frame.size.width, height: width)
        border.borderWidth = width
        textView.layer.addSublayer(border)

        let border2 = CALayer()
        let width2 = CGFloat(1)
        border2.borderColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0).cgColor
        border2.frame = CGRect(x: 0, y: passwordTextField.frame.origin.y + passwordTextField.frame.size.height - width2, width:  textView.frame.size.width, height: width2)
        border2.borderWidth = width2
        textView.layer.addSublayer(border2)
        
        textView.layer.masksToBounds = true
    }
    
    
}
