//
//  DecoderExtension.swift
//  CuremApp
//
//  Created by Gabriel Fernandes on 11/28/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation

extension Decodable {
    
    static func decode(_ dic: NSDictionary) throws -> Self {
        let data = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        
        let decoder = JSONDecoder()
        
        return try decoder.decode(Self.self, from: data!)
    }
    
}

extension Encodable {
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(self)
    }
    
    func encodeToDic() throws -> Dictionary<String, Any> {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        
        return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
    }
}
