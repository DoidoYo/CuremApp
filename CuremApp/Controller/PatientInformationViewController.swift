//
//  PatientInformationViewController.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/24/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class PatientInformationViewController: UIViewController {
    
    
    @IBOutlet weak var navyView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    
    @IBAction func correctButtonPress(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateAccountVC")
        self.showDetailViewController(vc!, sender: self)
    }
    
    override func viewDidLoad() {
        isHeroEnabled = true
        self.view.heroID = "codeAnim"
        navyView.heroModifiers = [.translate(y:50)]
        
        for v in self.view.subviews {
            v.heroModifiers = [.fade, .scale(0)]
        }
        
        super.viewDidLoad()
        
        if let patient = FirebaseHelper.pendingPatient {
            nameLabel.text = "\(patient.first_name) \(patient.last_name)"
            dobLabel.text = patient.dob
            phoneLabel.text = patient.phone
            sexLabel.text = patient.sex
        } else {
            print("ERROR: No pending patient found! shit")
        }
        
    }
    
    
    @IBAction func unwindToPatientInformationVC(segue:UIStoryboardSegue) { }
    
}
