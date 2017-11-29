//
//  HomeViewController.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/24/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import Charts
import MIBadgeButton_Swift
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var switcher: UISegmentedControl!
    
    @IBOutlet weak var dosageGraph: LineChartView!
    @IBOutlet weak var measurementGraph: LineChartView!
    
    @IBOutlet weak var conLabel: UILabel!
    @IBOutlet weak var meaLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var measurements: [MeasurementModel] = []
    var dosageList: [MeasurementModel] = []
    var concentrationList: [MeasurementModel] = []
    
    let LIGHT_GREY = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
    
    var chatVC:ChatViewController?
    
    @objc func showChat(_ sender:Any) {
        setChatBadge(nil)
        
        self.navigationController?.show(chatVC!, sender: self)
    }
    
    func setChatBadge(_ num: Int?) {
        if let num = num {
            //Custom
            let badgeButton : MIBadgeButton = MIBadgeButton(frame: CGRect(x:0, y:0, width:25, height:25))
            badgeButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
            badgeButton.badgeString = "\(num)";
            badgeButton.addTarget(self, action: #selector(self.showChat(_:)), for: .touchUpInside)
            let barButton : UIBarButtonItem = UIBarButtonItem(customView: badgeButton)
            self.navigationItem.rightBarButtonItems![1] = barButton
        } else {
            //Custom
            let badgeButton : MIBadgeButton = MIBadgeButton(frame: CGRect(x:0, y:0, width:25, height:25))
            badgeButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
            badgeButton.addTarget(self, action: #selector(self.showChat(_:)), for: .touchUpInside)
            let barButton : UIBarButtonItem = UIBarButtonItem(customView: badgeButton)
            self.navigationItem.rightBarButtonItems![1] = barButton
        }
    }
    
    @objc func switcherChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            dosageGraph.isHidden = false
            measurementGraph.isHidden = false
            conLabel.isHidden = false
            meaLabel.isHidden = false
            tableView.isHidden = true
        } else {
            dosageGraph.isHidden = true
            measurementGraph.isHidden = true
            conLabel.isHidden = true
            meaLabel.isHidden = true
            tableView.isHidden = false
        }
    }
    
    func updateLists() {
        for mea in measurements {
            if mea.type == 0 {  //consumption
                self.dosageList.append(mea)
            } else {
                self.concentrationList.append(mea)
            }
        }
        
        self.measurements.sort(by: {
            (first, next) in
            
            if first.time > next.time {
                return true
            }
            return false
        })
        self.dosageList.sort(by: {
            (first, next) in
            
            if first.time < next.time {
                return true
            }
            return false
        })
        self.concentrationList.sort(by: {
            (first, next) in
            
            if first.time < next.time {
                return true
            }
            return false
        })
        tableView.reloadData()
    }
    
    func updateGraphs() {
        var entries = [ChartDataEntry]()
        for mea in dosageList {
            let val = ChartDataEntry(x: mea.time, y: mea.measurement)
            entries.append(val)
        }
        
        let line1 = LineChartDataSet(values: entries, label: "")
        line1.colors = [UIColor(red:0.25, green:0.71, blue:0.95, alpha:1.0)]
        line1.circleColors = [UIColor(red:0.25, green:0.71, blue:0.95, alpha:1.0)]
        line1.circleRadius = 5
        line1.drawCircleHoleEnabled = false
        
        
        //dosage data
        line1.valueFont = line1.valueFont.withSize(13)
        let formatter = DefaultValueFormatter(decimals: 1)
        line1.valueFormatter = formatter
        
        line1.drawValuesEnabled = true
        line1.cubicIntensity = 10
        line1.lineWidth = 3
        //color under line
        let gradientColors = [UIColor(red:0.25, green:0.71, blue:0.95, alpha:1.0).cgColor, UIColor.white.cgColor] as CFArray
        let colorLocation:[CGFloat] = [1.0, 0.0]
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocation)
        line1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        line1.drawFilledEnabled = true
        
        let data = LineChartData()
        data.addDataSet(line1)
        
        dosageGraph.data = data
        
        
        
        //measurement data
        var entries2 = [ChartDataEntry]()
        for mea in concentrationList {
            let val = ChartDataEntry(x: mea.time, y: mea.measurement)
            entries2.append(val)
        }
        
        let line2 = LineChartDataSet(values: entries2, label: "")
        line2.colors = [UIColor(red:0.29, green:0.95, blue:0.51, alpha:1.0)]
        line2.circleColors = [UIColor(red:0.29, green:0.95, blue:0.51, alpha:1.0)]
        line2.circleRadius = 5
        line2.drawCircleHoleEnabled = false
        
        
        //dosage data
        line2.valueFont = line2.valueFont.withSize(13)
        let formatter2 = DefaultValueFormatter(decimals: 1)
        line2.valueFormatter = formatter2
        
        line2.drawValuesEnabled = true
        line2.cubicIntensity = 10
        line2.lineWidth = 3
        //color under line
        let gradientColors2 = [UIColor(red:0.29, green:0.95, blue:0.51, alpha:1.0).cgColor, UIColor.white.cgColor] as CFArray
        let colorLocation2:[CGFloat] = [1.0, 0.0]
        let gradient2 = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors2, locations: colorLocation2)
        line2.fill = Fill.fillWithLinearGradient(gradient2!, angle: 90.0)
        line2.drawFilledEnabled = true
        
        let data2 = LineChartData()
        data2.addDataSet(line2)
        
        measurementGraph.data = data2
        
        dosageGraph.notifyDataSetChanged()
        measurementGraph.notifyDataSetChanged()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.setChatBadge(nil)
        //data logic
        
        FirebaseHelper.getLatestMeasurements(completion: {
            measuremets in
            self.measurements = measuremets
            self.updateLists()
            self.updateGraphs()
        })
        
        //data logic -- END
    }
    
    override func viewDidLoad() {
        //test tk
//        do {
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//            let fetchRequest:NSFetchRequest<SavedMessage> = SavedMessage.fetchRequest()
//            let sort = NSSortDescriptor(key: "time", ascending: false)
//            fetchRequest.sortDescriptors = [sort]
//            let savedMessages = try context.fetch(fetchRequest)
//            for i in savedMessages {
//                context.delete(i)
//            }
//        } catch {
//            print("Fetching Failed")
//        }
        super.viewDidLoad()
        
        //setup chat
        chatVC = storyboard?.instantiateViewController(withIdentifier: "ChatVC") as? ChatViewController
        chatVC?.homeVC = self
        
        FirebaseHelper.getUser(completion: {
            (error) in
            if error == nil {
                self.chatVC?.initChat()
            }
        })
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setChatBadge(nil)
        tableView.isHidden = true
        switcher.addTarget(self, action: #selector(self.switcherChanged(_:)), for: .valueChanged)
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        //graph stuff
        dosageGraph.xAxis.valueFormatter = UnixToStringFormatter()
        measurementGraph.xAxis.valueFormatter = UnixToStringFormatter()
        
        //dosage
        
        dosageGraph.clipsToBounds = false
        dosageGraph.scaleXEnabled = false
        dosageGraph.scaleYEnabled = false
        dosageGraph.isUserInteractionEnabled = false
        //        dosageGraph.xAxis.avoidFirstLastClippingEnabled = true
        
        dosageGraph.chartDescription?.text = ""
        dosageGraph.tintColor = UIColor.red
        dosageGraph.xAxis.labelPosition = .bottom
        dosageGraph.rightAxis.enabled = false
        dosageGraph.leftAxis.enabled = false
        dosageGraph.leftAxis.gridColor = LIGHT_GREY
        dosageGraph.xAxis.gridColor = LIGHT_GREY
        
        
        dosageGraph.legend.enabled = false
        dosageGraph.leftAxis.axisLineWidth = 3
        dosageGraph.leftAxis.axisLineColor = UIColor(red:0.24, green:0.27, blue:0.33, alpha:1.0)
        dosageGraph.xAxis.setLabelCount(7, force: true)
        dosageGraph.xAxis.axisLineWidth = 3
        dosageGraph.xAxis.axisLineColor = UIColor(red:0.24, green:0.27, blue:0.33, alpha:1.0)
        
        //measurement
        measurementGraph.scaleXEnabled = false
        measurementGraph.scaleYEnabled = false
        measurementGraph.isUserInteractionEnabled = false
        
        measurementGraph.chartDescription?.text = ""
        measurementGraph.tintColor = UIColor.red
        measurementGraph.xAxis.labelPosition = .bottom
        measurementGraph.rightAxis.enabled = false
        measurementGraph.leftAxis.enabled = false
        measurementGraph.leftAxis.gridColor = LIGHT_GREY
        measurementGraph.xAxis.gridColor = LIGHT_GREY
        
        measurementGraph.legend.enabled = false
        measurementGraph.leftAxis.axisLineWidth = 3
        measurementGraph.leftAxis.axisLineColor = UIColor(red:0.24, green:0.27, blue:0.33, alpha:1.0)
        measurementGraph.xAxis.setLabelCount(7, force: true)
        measurementGraph.xAxis.axisLineWidth = 3
        measurementGraph.xAxis.axisLineColor = UIColor(red:0.24, green:0.27, blue:0.33, alpha:1.0)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell")
        let mea = measurements[indexPath.row]
        let image = cell?.viewWithTag(1) as! UIImageView
        let type = cell?.viewWithTag(2) as! UILabel
        let val = cell?.viewWithTag(3) as! UILabel
        let time = cell?.viewWithTag(4) as! UILabel
        
        
        
        let date = Date(timeIntervalSince1970: mea.time / 1000)
        
        let df = DateFormatter()
        df.dateFormat = "hh:mm a \n MM/dd/yyyy"
        
        time.text = df.string(from: date)
        
        if mea.type == 0 {
            image.image = #imageLiteral(resourceName: "pill")
            type.text = "Comsumption"
            val.text = "\(mea.measurement) mg"
        } else {
            image.image = #imageLiteral(resourceName: "voltmeter")
            type.text = "Reading"
            val.text = "\(mea.measurement) ng/mL"
        }
        
        return cell!
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return measurements.count
    }
    
    @IBAction func unwindToHomeVC(segue:UIStoryboardSegue) { }
    
    
}

