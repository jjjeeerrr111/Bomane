//
//  Stylist.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2017-01-23.
//  Copyright © 2017 com.bomane. All rights reserved.
//

import Foundation

struct Stylist {
    var firstName:String!
    var lastName:String!
    var id:Int!
    var locationId:Int = 3749
    var isSelected = false
    
    init?(dic: [String:Any]) {
        guard let first = dic["FirstName"] as? String, let last = dic["LastName"] as? String, let id = dic["ID"] as? Int else {return nil}
        
        self.firstName = first
        self.lastName = last
        self.id = id
    }
}
