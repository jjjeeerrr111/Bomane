//
//  CreditCard.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2017-02-06.
//  Copyright © 2017 com.bomane. All rights reserved.
//

import Foundation

class CreditCard: NSObject, NSCoding {
    
    
    var name:String!
    var zipCode:String!
    var numbers:String!
    var cvv:String!
    var expirationDate:Date!
    var expirationDateString:String!
    var last4:String!
    var type:String!
    var typeID:Int!
    
    init(name: String,zip:String,numbers:String,cvv:String,expDate:Date,expDateString:String, last4:String, type: String, typeID: Int) {
        self.name = name
        self.zipCode = zip
        self.numbers = numbers
        self.cvv = cvv
        self.expirationDate = expDate
        self.expirationDateString = expDateString
        self.last4 = last4
        self.type = type
        self.typeID = typeID
        super.init()
    }
    
    //MARK: NSCoding
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: CardKey.name)
        aCoder.encode(zipCode, forKey: CardKey.zipCode)
        aCoder.encode(numbers, forKey: CardKey.numbers)
        aCoder.encode(cvv, forKey: CardKey.cvv)
        aCoder.encode(expirationDate, forKey: CardKey.expirationDate)
        aCoder.encode(expirationDateString, forKey: CardKey.expirationString)
        aCoder.encode(last4, forKey: CardKey.last4)
        aCoder.encode(type, forKey: CardKey.type)
        aCoder.encode(typeID, forKey: CardKey.typeID)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let name = aDecoder.decodeObject(forKey: CardKey.name) as! String
        let zipCode = aDecoder.decodeObject(forKey: CardKey.zipCode) as! String
        let numbers = aDecoder.decodeObject(forKey: CardKey.numbers) as! String
        let cvv = aDecoder.decodeObject(forKey: CardKey.cvv) as! String
        let expDate = aDecoder.decodeObject(forKey: CardKey.expirationDate) as! Date
        let expString = aDecoder.decodeObject(forKey: CardKey.expirationString) as! String
        let last4 = aDecoder.decodeObject(forKey: CardKey.last4) as! String
        let type = aDecoder.decodeObject(forKey: CardKey.type) as! String
        let typeID = aDecoder.decodeObject(forKey: CardKey.typeID) as! Int
        
        self.init(name: name, zip: zipCode, numbers:numbers,cvv:cvv,expDate: expDate, expDateString: expString, last4: last4, type: type, typeID: typeID)
        
    }
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("CreditCard")
}

struct CardKey {
    static let name = "name"
    static let zipCode = "zipCode"
    static let numbers = "numbers"
    static let cvv = "cvv"
    static let expirationDate = "expirationDate"
    static let expirationString = "expirationString"
    static let last4 = "last4"
    static let type = "type"
    static let typeID = "typeID"
}
