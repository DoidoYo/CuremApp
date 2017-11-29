//
//  UserTypeViewController.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/24/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import Hero

class UserTypeViewController: UIViewController {
    
    @IBOutlet weak var newUserView: UIView!
    @IBOutlet weak var existingUserView: UIView!
    
    override func viewDidLoad() {
        existingUserView.heroID = "exist"
        newUserView.heroID = "codeAnim"
        
        for v in newUserView.subviews {
            v.heroModifiers = [.fade, .scale(0)]
        }
        
        for v in existingUserView.subviews {
            v.heroModifiers = [.fade, .scale(0)]
        }
        
        //for testing
        //for testing
        let model = LoginModel()
        model.email = "pat@gmail.com"
        model.password = "test123"
        
//        FirebaseHelper.login(model, completion: {
//            error in
//            if error == nil {
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
//                self.showDetailViewController(vc!, sender: self)
//            }
//        })
        
        
        super.viewDidLoad()
        
        let newTap = UITapGestureRecognizer(target: self, action: #selector(self.newUserTap(_:)))
        let existingTap = UITapGestureRecognizer(target: self, action: #selector(self.existingUserTap(_:)))
        
        newUserView.addGestureRecognizer(newTap)
        existingUserView.addGestureRecognizer(existingTap)
        
    }
    
    @objc func newUserTap(_ sender:UIPanGestureRecognizer) {
        let newUserVC = storyboard?.instantiateViewController(withIdentifier: "PatientCodeVC")
        self.showDetailViewController(newUserVC!, sender: self)
    }
    
    @objc func existingUserTap(_ sender:UIPanGestureRecognizer) {
        let newUserVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        self.showDetailViewController(newUserVC!, sender: self)
    }
    
    
    @IBAction func unwindToUserTypeVC(segue:UIStoryboardSegue) { }
}
