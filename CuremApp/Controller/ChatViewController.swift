//
//  ChatViewController.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/27/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ChatViewController: UITableViewController {
    
    var acView: UIView?
    var inText: UITextField?
    
    var displayedMessages:[MessageModel] = []
    var newMessages:[MessageModel] = []
    
    var homeVC:HomeViewController!
    
    var showWarning: Bool {
        get {
            let date = Date()
            
            let df = DateFormatter()
            df.dateFormat = "MM/dd/yyyy"
            let dateString = df.string(from: date)
            
            let earlyStr = "9:00 AM \(dateString)"
            let lateStr = "5:00 PM \(dateString)"
            
            let df2 = DateFormatter()
            df2.dateFormat = "h:mm a MM/dd/yyyy"
            
            let earlyDate = df2.date(from: earlyStr)
            let lateDate = df2.date(from: lateStr)
            
            if date > earlyDate! && date < lateDate! {
                return false
            }
            return true
        }
    }
    
    var inNewMsgCount: Int {
        get {
            var t = 0
            for i in newMessages {
                if i.sender == 1 {
                    t += 1
                }
            }
            return t
        }
    }
    
    override func viewDidLoad() {
        print(showWarning)
        super.viewDidLoad()
        
        //load accessory view
        acView = Bundle.main.loadNibNamed("AccessoryView", owner: self, options: nil)?.first as? UIView
        inText = acView?.viewWithTag(1) as? UITextField
        
        let sendBtn = acView?.viewWithTag(2) as! UIButton
        sendBtn.addTarget(self, action: #selector(self.sendMsg(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow(notification:)), name: .UIKeyboardDidShow, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        saveMsgs()
    }
    
    func saveMsgs() {
        //save new msgs into memory
        if newMessages.count > 0 {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            for msg in newMessages {
                let smsg = SavedMessage(context: context) // Link Task & Context
                smsg.id = msg.id
                smsg.time = msg.time
                smsg.sender = Int16(msg.sender)
                smsg.text = msg.text
                
                FirebaseHelper.savedUser!.addToSavedMessages(smsg)
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            newMessages = []
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveMsgs()
    }
    
    func initChat() {
        _ = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //get User's saved msg
        let savedMessages: [SavedMessage]! = FirebaseHelper.savedUser.flatMap({
            user in
            user.savedMessages?.allObjects as? [SavedMessage]
        })
        //show messages
        for item in (savedMessages) {
            let msg = MessageModel(id: item.id!, sender: Int(item.sender), text: item.text!, time: item.time)
            displayedMessages.append(msg)
        }
        //order in increasing order so that latest is always at the bottom of the tableview
        displayedMessages.sort(by: {
            (first, next) in
            if first.time < next.time {
                return true
            }
            return false
        })
        //get time of last message
        var time: Double = 0
        if displayedMessages.count > 0 {
            let first = displayedMessages[displayedMessages.count - 1]
            time = first.time + 0.1
        }
        FirebaseHelper.observeChat(from: time, completion: {
            (msg) in
            self.displayedMessages.append(msg)
            self.newMessages.append(msg)
            
            if (self.isViewLoaded) {
                let indexPath = IndexPath(row: self.displayedMessages.count-1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .none)
                self.scrollToBottom(animated: false)
            }
            
            //update Badge in homeVC
            if self.viewIfLoaded?.window == nil {
                let count = self.inNewMsgCount
                self.homeVC.setChatBadge(count == 0 ? nil : count)
            } else {
                self.homeVC.setChatBadge(nil)
            }
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToBottom(animated: true)
    }
    
    @objc func keyBoardDidShow(notification: NSNotification) {
        if inText!.isFirstResponder {
            scrollToBottom(animated: true)
        }
    }
    
    func scrollToBottom(animated: Bool) {
        
        if displayedMessages.count != 0 {
            if showWarning {
                let indexPath = IndexPath(row: 0, section: 1)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            } else {
                let indexPath = IndexPath(row: displayedMessages.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    @objc func sendMsg(_ sender: UIButton) {
        if !(inText!.text?.isEmpty)! {
            let msg = MessageModel(id: "", sender: 0, text: inText!.text!, time: Double(Date().timeIntervalSince1970) * 1000)
            FirebaseHelper.sendMsg(msg)
            inText?.text = ""
        }
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
        if indexPath.section == 0 {
            var cell:UITableViewCell!
            let msg = displayedMessages[indexPath.row]
            
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noCell")
            
            (cell?.viewWithTag(1) as! UILabel).text = "Doctor Unavailable"
            return cell!
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if showWarning {
            return 2
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedMessages.count
    }
    
}



