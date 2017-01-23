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
    var apiKey:String?
    var password:String?
    var customerId:String?
    
    init(first: String, last: String, email: String, apiKey: String? = nil, password: String? = nil, customerId: String? = nil) {
        self.firstName = first
        self.lastName = last
        self.email = email
        self.apiKey = apiKey
        self.password = password
        self.customerId = customerId
        super.init()
    }
    
    init(dictionary: [String:Any], apiKey: String?) {
        guard let first = dictionary["first_name"] as? String, let last = dictionary["last_name"] as? String, let email = dictionary["email"] as? String else {return}
        self.firstName = first
        self.lastName = last
        self.email = email
        
        if let key = apiKey {
            self.apiKey = key
        }
    }
    
    //MARK: NSCoding
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: PropertyKey.firstName)
        aCoder.encode(lastName, forKey: PropertyKey.lastName)
        aCoder.encode(email, forKey: PropertyKey.email)
        aCoder.encode(apiKey, forKey: PropertyKey.apiKey)
        aCoder.encode(password, forKey: PropertyKey.password)
        aCoder.encode(customerId, forKey: PropertyKey.customerId)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let first = aDecoder.decodeObject(forKey: PropertyKey.firstName) as! String
        let last = aDecoder.decodeObject(forKey: PropertyKey.lastName) as! String
        let email = aDecoder.decodeObject(forKey: PropertyKey.email) as! String
        let apiKey = aDecoder.decodeObject(forKey: PropertyKey.apiKey) as? String
        let password = aDecoder.decodeObject(forKey: PropertyKey.password) as? String
        let customerId = aDecoder.decodeObject(forKey: PropertyKey.customerId) as? String
        self.init(first: first, last: last, email: email, apiKey: apiKey, password: password, customerId: customerId)
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
