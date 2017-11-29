//
//  ChatViewController.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/27/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit


class ChatViewController: UITableViewController {
    
    var acView: UIView?
    
    var inText: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load accessory view
        acView = Bundle.main.loadNibNamed("AccessoryView", owner: self, options: nil)?.first as! UIView
        inText = acView?.viewWithTag(1) as! UITextField
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow(notification:)), name: .UIKeyboardDidShow, object: nil)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scroolToBottom(animated: false)
    }
    
    @objc func keyBoardDidShow(notification: NSNotification) {
        if inText!.isFirstResponder {
            scroolToBottom(animated: true)
        }
    }
    
    func scroolToBottom(animated: Bool) {
        let indexPath = IndexPath(row: 9, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
    
    func addMsg(_ msg: String) {
        
        
        
    }
    
    override var inputAccessoryView: UIView? {
        return acView!
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
}

extension ChatViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "inCell")
        
        if indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "outCell")
        }
        
        return cell!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
}



