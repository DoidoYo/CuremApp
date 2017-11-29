//
//  PatientCodeViewController.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/24/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import Hero

class PatientCodeViewController: UIViewController {
    
    @IBOutlet weak var inputText: UITextField!
    
    @IBAction func continueButtonPress(_ sender: Any) {
        
        if !inputText.text!.isEmpty {
            FirebaseHelper.getPatientFrom(code: inputText.text!, completion: {
                (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PatientInformationVC")
                    self.showDetailViewController(vc!, sender: self)
                }
            })
        }
        
    }
    
    @IBAction func backButtonPress(_ sender: Any) {
    }
    override func viewDidLoad() {
        isHeroEnabled = true
        self.view.heroID = "codeAnim"
        
        for v in self.view.subviews {
            v.heroModifiers = [.fade, .scale(0)]
        }
        
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //textfield look
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: inputText.frame.size.height - width, width:  inputText.frame.size.width, height: inputText.frame.size.height)
        
        border.borderWidth = width
        inputText.layer.addSublayer(border)
        inputText.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        inputText.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        inputView?.resignFirstResponder()
    }
    
    @IBAction func unwindToPatientCodeVC(segue:UIStoryboardSegue) { }
    
}
