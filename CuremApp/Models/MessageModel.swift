//
//  MessageModel.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/29/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation

struct MessageModel: Codable {
    var id:String
    var sender:Int
    var text:String
    var time:Double
}
