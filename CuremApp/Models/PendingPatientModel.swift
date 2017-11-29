//
//  PendingPatientModel.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/28/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation

struct PendingPatientModel: Codable {
    var code:String
    var dob:String
    var doc:String
    var first_name:String
    var last_name:String
    var phone: String
    var sex: String
}
