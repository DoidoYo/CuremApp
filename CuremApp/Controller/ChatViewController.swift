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
    
    var messages:[MessageModel] = []
    
    var parentVC:HomeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parentVC = self.navigationController?.viewControllers[0] as! HomeViewController
        
        //load accessory view
        acView = Bundle.main.loadNibNamed("AccessoryView", owner: self, options: nil)?.first as! UIView
        inText = acView?.viewWithTag(1) as! UITextField
        
        let sendBtn = acView?.viewWithTag(2) as! UIButton
        sendBtn.addTarget(self, action: #selector(self.sendMsg(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow(notification:)), name: .UIKeyboardDidShow, object: nil)
        
//        FirebaseHelper.getChatMsg(completion: {
//            (msgs) in
//            self.messages = msgs
//            self.updateMsgs()
//            self.scroolToBottom(animated: false)
//        })
        
        FirebaseHelper.observeChat(completion: {
            (msg) in
            self.messages.append(msg)
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .none)
            self.scroolToBottom(animated: false)            
        })
    }
    
//    func updateMsgs(_ msgs: [MessageModel]) {
//        for item in msgs {
//            self.messages.append(item)
//        }
//        let indexPath = IndexPath(row: self.messages.count-1, section: 0)
//        self.tableView.insertRows(at: [indexPath], with: .none)
//        self.scroolToBottom(animated: false)
//    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func keyBoardDidShow(notification: NSNotification) {
        if inText!.isFirstResponder {
            scroolToBottom(animated: true)
        }
    }
    
    func scroolToBottom(animated: Bool) {
        let indexPath = IndexPath(row: messages.count-1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
    
    @objc func sendMsg(_ sender: UIButton) {
        
        let msg = MessageModel(id: "", sender: 0, text: inText!.text!, time: Double(Date().timeIntervalSince1970) * 1000)
        
        FirebaseHelper.sendMsg(msg)
        
        inText?.text = ""
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
        var cell:UITableViewCell!
        let msg = messages[indexPath.row]
    
        if msg.sender == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "outCell")
            let name = cell.viewWithTag(1) as! UILabel
            name.text = "You"
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "inCell")
            let name = cell.viewWithTag(1) as! UILabel
            name.text = "Doctor"
        }
        
        let date = Date(timeIntervalSince1970: msg.time / 1000)
        let df = DateFormatter()
        df.dateFormat = "h:mm a MMM dd, yyyy"
        let time = cell.viewWithTag(2) as! UILabel
        time.text = df.string(from: date)
        
        let text = cell.viewWithTag(3) as! UITextView
        text.text = msg.text
        
        return cell!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
}



