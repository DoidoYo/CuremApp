//
//  HomeViewController.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/24/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make button rounded
        chatButton.layer.cornerRadius = 30
        chatButton.clipsToBounds = true
        
        addButton.layer.cornerRadius = 30
        addButton.clipsToBounds = true
        
        //add underline to nav item
        
        
    }
    
    @IBAction func unwindToHomeVC(segue:UIStoryboardSegue) { }
    
}
