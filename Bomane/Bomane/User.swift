//
//  User.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2017-01-20.
//  Copyright © 2017 com.bomane. All rights reserved.
//

import Foundation

class User : NSObject, NSCoding {
    
    var firstName:String!
    var lastName:String!
    var email:String!
    var phoneNumber:String!
    var apiKey:String?
    var password:String?
    var customerId:Int?
    
    init(first: String, last: String, email: String, phone:String, apiKey: String? = nil, password: String? = nil, customerId: Int? = nil) {
        self.firstName = first
        self.lastName = last
        self.email = email
        self.apiKey = apiKey
        self.password = password
        self.customerId = customerId
        self.phoneNumber = phone
        super.init()
    }
    
    init?(dictionary: [String:Any]) {
        guard let token = dictionary["access_token"] as? String else {return nil}
        guard let customer = dictionary["Customer"] as? [String:Any], let customerId = customer["CustomerID"] as? Int, let customerDic = customer["Customer"] as? [String:Any], let first = customerDic["FirstName"] as? String, let last = customerDic["LastName"] as? String, let email = customerDic["Email"] as? String, let number = customerDic["HomePhone"] as? String else {return nil}
        self.firstName = first
        self.lastName = last
        self.email = email
        self.apiKey = token
        self.customerId = customerId
        self.phoneNumber = number
    }
    
    //MARK: NSCoding
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: PropertyKey.firstName)
        aCoder.encode(lastName, forKey: PropertyKey.lastName)
        aCoder.encode(email, forKey: PropertyKey.email)
        aCoder.encode(apiKey, forKey: PropertyKey.apiKey)
        aCoder.encode(password, forKey: PropertyKey.password)
        aCoder.encode(customerId, forKey: PropertyKey.customerId)
        aCoder.encode(phoneNumber, forKey: PropertyKey.number)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let first = aDecoder.decodeObject(forKey: PropertyKey.firstName) as! String
        let last = aDecoder.decodeObject(forKey: PropertyKey.lastName) as! String
        let email = aDecoder.decodeObject(forKey: PropertyKey.email) as! String
        let number = aDecoder.decodeObject(forKey: PropertyKey.number) as! String
        let apiKey = aDecoder.decodeObject(forKey: PropertyKey.apiKey) as? String
        let password = aDecoder.decodeObject(forKey: PropertyKey.password) as? String
        let customerId = aDecoder.decodeObject(forKey: PropertyKey.customerId) as? Int
        self.init(first: first, last: last, email: email,phone: number, apiKey: apiKey, password: password, customerId: customerId)
    }
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("User")
}

struct PropertyKey {
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let email = "email"
    static let number = "number"
    static let apiKey = "apiKey"
    static let password = "password"
    static let customerId = "customerId"
}
