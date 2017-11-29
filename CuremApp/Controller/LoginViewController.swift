//
//  LoginViewController.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/28/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonPress(_ sender: Any) {
        
        print("LOGGING")
        
        let loginModel = LoginModel()
        loginModel.email = emailTextField.text
        loginModel.password = passwordTextField.text
        
        FirebaseHelper.login(loginModel, completion: {
            (error) in
            
            if let error = error {
                //TK show some error on screen
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
    }
    
}
