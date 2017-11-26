//
//  UnixToStringFormatter.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/26/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import Charts

class UnixToStringFormatter: NSObject, IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        
        let df = DateFormatter()
        df.dateFormat = "MMM dd"
        
        let wd = df.shortWeekdaySymbols[Calendar.current.component(.weekday, from: date)-1]
        
        return "\(df.string(from: date)) \n \(wd)"
    }
    
}
