//
//  PatientCodeViewController.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/24/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class PatientCodeViewController: UIViewController {
    
    @IBOutlet weak var inputText: UITextField!
    
    @IBAction func continueButtonPress(_ sender: Any) {
        
    }
    @IBAction func backButtonPress(_ sender: Any) {
    }
    override func viewDidLoad() {
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
    
}
