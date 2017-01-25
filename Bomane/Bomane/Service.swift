//
//  Service.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2016-11-27.
//  Copyright © 2016 com.bomane. All rights reserved.
//

import Foundation

struct Service {
    var name:String!
    var description:String?
    var duration:Int?
    var price:Double?
    var id:Int?
    var isSelected = false

    init(name: String, description: String? = nil, duration: Int? = nil, price: Double? = nil, id: Int? = nil) {
        self.name = name
        self.description = description
        self.duration = duration
        self.price = price
        self.id = id
    }
    
    init?(dic: [String:Any]) {
        guard let name = dic["Name"] as? String, let time = dic["TotalDuration"] as? Int, let priceDic = dic["Price"] as? [String:Any], let totalAmount = priceDic["Amount"] as? Double, let id = dic["ID"] as? Int else {
            print("FAILED TO CREATE TREATMENT OBJECT")
            return nil}
        
        self.name = name
        
        if let descrip = dic["Description"] as? String {
            self.description = descrip
        }
        
        self.duration = time
        self.price = totalAmount
        self.id = id
    }
}
