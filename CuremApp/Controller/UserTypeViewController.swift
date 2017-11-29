//
//  UserTypeViewController.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/24/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class UserTypeViewController: UIViewController {
    
    @IBOutlet weak var newUserView: UIView!
    @IBOutlet weak var existingUserView: UIView!
    
    override func viewDidLoad() {
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
