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
                print("SUCESS GETTING API KEY: ", json)
                let status = json["IsSuccess"].stringValue
                
                if status == "true" {
                    let token = json["access_token"].stringValue
                    completion(token)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                let json = JSON(data: response.data!)
                print("ERROR GETTING API KEY: ", json)
                print("ERROR: ",error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    //MARK: FIND LOCATIONS
    
    /*************************
     
     Content-Type: application/json; charset=utf-8
     POST https://apicurrent-app.booker.ninja/WebService4/json/CustomerService.svc/locations
     {
     "BrandAccountName": "",
     "BrandID": null,
     "BusinessName": "",
     "FeatureLevel": null,
     "PageNumber": 1,
     "PageSize": 5,
     "SortBy": [
     {
     "SortBy": "Name",
     "SortDirection": 0
     }
     ],
     "UsePaging": true,
     "access_token": "3edb7157-1e34-4bf5-aa16-e18c1772042b"
     }
    **************************/
    
    func findLocations(with token: String, completion: @escaping (Bool) -> Void) {
        let urlString = getBaseURL() + "locations"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            ]
        
        let params:Parameters = ["access_token":token]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                let status = json["IsSuccess"].stringValue
                print("SUCESS GETTING LOCATIONS: ", json)
                if status == "true" {
                    //let customerId = json["CustomerID"].stringValue
                    completion(true)
                } else {
                    //let errorMsg = json["ErrorMessage"].stringValue
                    completion(false)
                }
            case .failure(let error):
                let json = JSON(data: response.data!)
                print("ERROR GETTING LOCATIONS: ", json)
                print("ERROR: ",error.localizedDescription)
                completion(false)
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
    
    func createUserAccount(with user: User, completion: @escaping (Bool,Int?,String?) -> Void) {
        
        let urlString = getBaseURL() + "customer/account"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]
        
        guard let token = user.apiKey else {
            completion(false,nil,"No API key")
            return}
        //location ID and home phone are required fields. lets just add wtvr
        let params:Parameters = ["Email" : user.email, "FirstName" : user.firstName, "LastName" : user.lastName, "access_token":token, "Password":user.password!, "LocationID" : 3749, "HomePhone":"1234567890"]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                let status = json["IsSuccess"].stringValue
                print("SUCESS CREATING USER: ", json)
                if status == "true" {
                    let customerId = json["CustomerID"].intValue
                    completion(true,customerId,nil)
                } else {
                    let errorMsg = json["ErrorMessage"].stringValue
                    completion(false,nil,errorMsg)
                }
            case .failure(let error):
                let json = JSON(data: response.data!)
                print("ERROR CREATING USER: ", json)
                print("ERROR: ",error.localizedDescription)
                completion(false,nil,nil)
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
    
    func login(email: String, password: String, completion: @escaping (User?) -> Void) {
        let urlString = getBaseURL() + "customer/login"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            ]
        let params:Parameters = ["Email" : email, "Password":password,"client_id":Constants.clientId, "client_secret":Constants.clientSecret, "LocationID" : 3749]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            
            switch response.result {
            case .success:
                guard let json = JSON(data: response.data!).dictionaryObject else {
                    completion(nil)
                    return
                }
                print("SUCESS LOGGING IN USER: ", json)
                guard let user = User(dictionary: json) else {
                    completion(nil)
                    return
                }
                completion(user)
            case .failure(let error):
                let json = JSON(data: response.data!)
                print("ERROR LOGGING IN USER: ", json)
                print("ERROR: ",error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    //MARK: FORGOT PASSWORD
    
    /****************************
     
     Content-Type: application/json; charset=utf-8
     POST https://apicurrent-app.booker.ninja/WebService4/json/CustomerService.svc/forgot_password/custom
     {
         "BaseUrlOfHost": "http://example.com/reset_password",
         "BrandID": null,
         "Email": "testcustomer@booker.com",
         "Firstname": "Test",
         "LocationID": 3749,
         "SupressQueryString": true,
         "access_token": "66282713-c82c-4159-ab2a-63629d62f83d"
     }
    *****************************/
    
    
    //MARK: FIND TREATMENT SERVICES
    
    /*********************************
     Content-Type: application/json; charset=utf-8
     POST https://apicurrent-app.booker.ninja/WebService4/json/CustomerService.svc/treatments
     {
     "AllowOnGiftCertificateSale": null,
     "CategoryID": 30,
     "EmployeeID": 58125,
     "LocationID": 3749,
     "PageNumber": 1,
     "PageSize": 10,
     "SortBy": [
     {
     "SortBy": "Name",
     "SortDirection": "Ascending"
     }
     ],
     "SubCategoryID": 218,
     "UsePaging": true,
     "ExcludeClassesAndWorkshops": null,
     "OnlyClassesAndWorkshops": null,
     "SkipLoadingRoomsAndEmployees": null,
     "DurationTypeID": null,
     "ExcludeCoupleServices": null,
     "ExcludeMembersOnly": null,
     "IncludeEmployeeTreatment": true,
     "RoomID": null,
     "BrandID": null,
     "access_token": "66282713-c82c-4159-ab2a-63629d62f83d"
     }
    **********************************/
    
    func getServices() {
        guard let user = DatabaseController.shared.loadUser() else {return}
        let urlString = getBaseURL() + "treatments"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            ]
        let params:Parameters = ["access_token":user.apiKey! , "LocationID" : 3749]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                print("SUCESS LOADING SERVICES: ", json)
                
            case .failure(let error):
                let json = JSON(data: response.data!)
                print("ERROR LOADING SERVICES: ", json)
                print("ERROR: ",error.localizedDescription)
            }
        }
    }

}
