//
//  SettingsViewController.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/29/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class SettingsViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("")
            <<< ButtonRow() {
                $0.title = "Change User Picture"
            }
        form +++ Section("")
            <<< ButtonRow() {
                $0.title = "Log Out"
        }.cellUpdate({
            (cell, row) in
            cell.textLabel?.textColor = UIColor.red
        }).onCellSelection({
            (cell, row) in
            FirebaseHelper.logout()
            self.performSegue(withIdentifier: "unwindToUserTypeSegue", sender: nil)
        })
    }
    
}
