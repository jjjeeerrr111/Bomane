//
//  NetworkController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2017-01-22.
//  Copyright © 2017 com.bomane. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

struct Constants {
    static let clientId = "FGytHvpskaBZ"
    static let clientSecret = "DjlPU5LNHHzI"
}

class NetworkController {
    
    static let shared = NetworkController()
    
    func getBaseURL() -> String {
        return "https://apicurrent-app.booker.ninja/WebService4/json/CustomerService.svc/"
    }
    
    func getAccessToken(completion: @escaping (String?) -> Void) {
        let urlString =  getBaseURL() + "access_token?client_id=FGytHvpskaBZ&client_secret=DjlPU5LNHHzI&grant_type=client_credentials"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]
        Alamofire.request(urlString, method: .get, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                let token = json["access_token"].stringValue
                print("SUCESS GETTING API KEY: ", json)
                completion(token)
            case .failure(let error):
                let json = JSON(data: response.data!)
                print("ERROR GETTING API KEY: ", json)
                print("ERROR: ",error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    //MARK: CREATE CUSTOMER ACCOUNT
    
    /**************************
     Content-Type: application/json; charset=utf-8
     POST https://apicurrent-app.booker.ninja/WebService4/json/CustomerService.svc/customer/account
     {
         "Password": "test",
         "Address": {
             "City": "New York",
             "Country": {
                 "ID": 1,
                 "Name": ""
             },
             "State": "NY",
             "Street1": "22 Cortlandt Street",
             "Street2": "",
             "Zip": "10007"
         },
         "AllowReceiveEmails": null,
         "AllowReceiveSMS": null,
         "CellPhone": "",
         "Email": "testcustomer@booker.com",
         "FirstName": "Test",
         "GUID": "",
         "HomePhone": "1234567890",
         "LastName": "Customer",
         "LocationID": 3749,
         "OriginationID": null,
         "WorkPhone": "",
         "MobilePhoneCarrierID": null,
         "GenderID": null,
         "RequireCustomerPhone": null,
         "RequireCustomerAddress": null,
         "DateOfBirth": null,
         "access_token": "66282713-c82c-4159-ab2a-63629d62f83d"
     }
    ***************************/
    
    func createUserAccount(with user: User, completion: @escaping (Bool,String?) -> Void) {
        
        let urlString = getBaseURL() + "customer/account"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]
        
        //location ID and home phone are required fields. lets just add wtvr
        let params:Parameters = ["Email" : user.email, "FirstName" : user.firstName, "LastName" : user.lastName, "access_token":user.apiKey!, "Password":user.password!, "LocationID" : 3749, "HomePhone":"1234567890"]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                let status = json["IsSuccess"].stringValue
                print("SUCESS CREATING USER: ", json)
                if status == "true" {
                    let customerId = json["CustomerID"].stringValue
                    completion(true,customerId)
                } else {
                    let errorMsg = json["ErrorMessage"].stringValue
                    completion(false,errorMsg)
                }
            case .failure(let error):
                let json = JSON(data: response.data!)
                print("ERROR CREATING USER: ", json)
                print("ERROR: ",error.localizedDescription)
                completion(false,nil)
            }
        }
    }
    
    //MARK: LOGIN USER
    
    /***********************
     Content-Type: application/json; charset=utf-8
     POST https://apicurrent-app.booker.ninja/WebService4/json/CustomerService.svc/customer/login
     {
         "Email": "apisample@booker.com",
         "LocationID": 3749,
         "Password": "testtest",
         "BrandID": null,
         "client_id": "CVwkWviKzOkk",
         "client_secret": "SYB6F0KxuJPi",
         "grant_type": ""
     }
    ************************/
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let urlString = getBaseURL() + "customer/login"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            ]
        let params:Parameters = ["Email" : email, "Password":password,"client_id":Constants.clientId, "client_secret":Constants.clientSecret]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                print("SUCESS LOGGING IN USER: ", json)
                completion(true)
            case .failure(let error):
                let json = JSON(data: response.data!)
                print("ERROR LOGGING IN USER: ", json)
                print("ERROR: ",error.localizedDescription)
                completion(false)
            }
        }
    }

}
