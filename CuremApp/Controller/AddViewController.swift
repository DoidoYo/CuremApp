//
//  AddViewController.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/24/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class AddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var dateTF: UITextField?
    var timeTF: UITextField?
    var valueTF: UITextField?
    @IBOutlet weak var typeSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ADD", style: .done, target: self, action: #selector(addPressed(_:)))
    }
    
    @objc func addPressed(_ sender: Any) {
        if !valueTF!.text!.isEmpty {
            let type = typeSegment.selectedSegmentIndex
            
            let dateString = "\(timeTF!.text!) \(dateTF!.text!)"
            let df = DateFormatter()
            df.dateFormat = "h:mm a MMM dd, yyyy"
            let date = df.date(from: dateString)
            let unix = (date?.timeIntervalSince1970)! * 1000
            
            let meaModel = MeasurementModel(measurement: Double(valueTF!.text!)!, time: unix, type: type)
            
            FirebaseHelper.setMeasurement(meaModel)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    var fr: UITextField?
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell")
        
        if indexPath.row == 0 {
            let text = cell?.viewWithTag(1) as! UILabel
            let val = cell?.viewWithTag(2) as! UITextField
            
            text.text = "Date"
            val.delegate = self
            dateTF = val
            
            
            let df = DateFormatter()
            df.dateStyle = .medium
            df.timeStyle = .none
            val.text = df.string(from: Date())
        } else if indexPath.row == 1 {
            let text = cell?.viewWithTag(1) as! UILabel
            let val = cell?.viewWithTag(2) as! UITextField
            
            text.text = "Time"
            val.delegate = self
            timeTF = val
            
            let df = DateFormatter()
            df.dateStyle = .none
            df.timeStyle = .short
            val.text = df.string(from: Date())
        } else if indexPath.row == 2 {
            let text = cell?.viewWithTag(1) as! UILabel
            let val = cell?.viewWithTag(2) as! UITextField
            
            valueTF = val
            text.text = "Value"
            val.text = ""
            val.placeholder = "Your data"
            
            val.inputView = nil
            val.keyboardType = .decimalPad
            fr = val
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            let cell = tableView.cellForRow(at: indexPath)
            
            let text = cell?.viewWithTag(2) as! UITextField
            text.becomeFirstResponder()
        } else if indexPath.row == 0 {
            let cell = tableView.cellForRow(at: indexPath)
            
            let text = cell?.viewWithTag(2) as! UITextField
            text.becomeFirstResponder()
        } else if indexPath.row == 2 {
            let cell = tableView.cellForRow(at: indexPath)
            
            let text = cell?.viewWithTag(2) as! UITextField
            text.becomeFirstResponder()
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let dp = UIDatePicker()
        if textField == timeTF! {
            dp.datePickerMode = .time
            dp.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)
            textField.inputView = dp
        } else if textField == dateTF {
            dp.datePickerMode = .date
            dp.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
            textField.inputView = dp
        }
    }
    
    @objc func timePickerValueChanged(_ sender: UIDatePicker) {
        let df = DateFormatter()
        df.dateStyle = .none
        df.timeStyle = .short
        timeTF!.text = df.string(from: sender.date)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        dateTF!.text = df.string(from: sender.date)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
            fr?.becomeFirstResponder()
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fr?.resignFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame.size = tableView.contentSize
    }
    
}
