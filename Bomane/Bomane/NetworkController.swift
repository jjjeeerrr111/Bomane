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
    let development = false
    //DEV API: "https://apicurrent-app.booker.ninja/WebService4/json/CustomerService.svc/"
    //PROD API: "https://app.secure-booker.com/webservice4/json/CustomerService.svc"
    func getBaseURL() -> String {
        if development {
            //dev
            return "https://apicurrent-app.booker.ninja/WebService4/json/CustomerService.svc/"
        } else {
            //prod
            return "https://app.secure-booker.com/webservice4/json/CustomerService.svc/"
        }
    }
    
    //MARK: Check if access token is valid
    /*************************
     Content-Type: application/json; charset=utf-8
     POST https://apicurrent-app.booker.ninja/WebService4/json/CustomerService.svc/authenticate?access_token={access_token}
     {
     "access_token": "66282713-c82c-4159-ab2a-63629d62f83d"
     }
    *************************/
    
    func checkIfTokenValid(token: String, completion: @escaping (Bool) -> Void) {
        let urlString = getBaseURL() + "authenticate?access_token=\(token)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            ]
        
        let params:Parameters = ["access_token":token]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                let status = json["IsSuccess"].stringValue
                
                if status == "true" {
                    //access token still valid
                    completion(true)
                } else {
                    //access token invalid
                    completion(false)
                }
            case .failure:
                completion(false)
            }
        }
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
                let token = json["access_token"].stringValue
                completion(token)
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
        let params:Parameters = ["Email" : user.email, "FirstName" : user.firstName, "LastName" : user.lastName, "access_token":token, "Password":user.password!, "LocationID" : 37514, "HomePhone":user.phoneNumber]
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
                    if errorMsg == "invalid access token" {
                        DatabaseController.shared.logoutUser()
                        AppDelegate.shared().showLogin()
                    }
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
        let params:Parameters = ["Email" : email, "Password":password,"client_id":Constants.clientId, "client_secret":Constants.clientSecret, "LocationID" : 37514]
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
    
    func getServices(employeeId: Int? = nil, completion: @escaping ([Service]?) -> Void) {
        guard let user = DatabaseController.shared.loadUser() else {
            completion(nil)
            return
        }
        let urlString = getBaseURL() + "treatments"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            ]
        
        var params:Parameters = ["access_token":user.apiKey! , "LocationID" : 37514]
        if let id = employeeId {
            params = ["access_token":user.apiKey! , "LocationID" : 37514, "EmployeeID" : id]
        }
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                print("SUCESS LOADING SERVICES: ", json)
                let status = json["IsSuccess"].stringValue
                if status == "true" {
                    var services:[Service] = []
                    let array = json["Treatments"].arrayValue
                    for item in array {
                        guard let dic = item.dictionaryObject else {continue}
                        if let service = Service(dic: dic) {
                            services.append(service)
                        }
                    }
                    completion(services)
                } else {
                    let msg = json["ErrorMessage"].stringValue
                    if msg == "invalid access token" {
                        DatabaseController.shared.logoutUser()
                        AppDelegate.shared().showLogin()
                    }
                    completion(nil)
                }
                
                
            case .failure(let error):
                let json = JSON(data: response.data!)
                print("ERROR LOADING SERVICES: ", json)
                print("ERROR: ",error.localizedDescription)
            }
        }
    }
    
    
    func getServicesAsGuest(employeeId: Int? = nil,token:String, completion: @escaping ([Service]?) -> Void) {

        let urlString = getBaseURL() + "treatments"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            ]
        
        var params:Parameters = ["access_token":token , "LocationID" : 37514]
        if let id = employeeId {
            params = ["access_token":token , "LocationID" : 37514, "EmployeeID" : id]
        }
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                print("SUCESS LOADING SERVICES: ", json)
                let status = json["IsSuccess"].stringValue
                if status == "true" {
                    var services:[Service] = []
                    let array = json["Treatments"].arrayValue
                    for item in array {
                        guard let dic = item.dictionaryObject else {continue}
                        if let service = Service(dic: dic) {
                            services.append(service)
                        }
                    }
                    completion(services)
                } else {
                    let msg = json["ErrorMessage"].stringValue
                    if msg == "invalid access token" {
                        DatabaseController.shared.logoutUser()
                        AppDelegate.shared().showLogin()
                    }
                    completion(nil)
                }
                
                
            case .failure(let error):
                let json = JSON(data: response.data!)
                print("ERROR LOADING SERVICES: ", json)
                print("ERROR: ",error.localizedDescription)
            }
        }
    }
    
    
    
    //MARK: GET EMPLOYESS
    /*********************************
     
     Content-Type: application/json; charset=utf-8
     POST https://apicurrent-app.booker.ninja/WebService4/json/CustomerService.svc/employees
     {
     "IgnoreFreelancers": null,
     "LocationID": 3749,
     "OnlyIncludeActiveEmployees": null,
     "PageNumber": 1,
     "PageSize": 10,
     "SortBy": [
     {
     "SortBy": "LastName",
     "SortDirection": "Ascending"
     }
     ],
     "TreatmentID": 304032,
     "UsePaging": true,
     "access_token": "66282713-c82c-4159-ab2a-63629d62f83d"
     }
    **********************************/
    
    func getEmployees(treatmentId: Int, completion: @escaping ([Stylist]?) -> Void) {
        guard let user = DatabaseController.shared.loadUser() else {
            completion(nil)
            return
        }
        let urlString = getBaseURL() + "employees"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            ]
        let params:Parameters = ["access_token":user.apiKey! , "LocationID" : 37514, "TreatmentID" : treatmentId]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                print("SUCESS LOADING EMPLOYEES: ", json)
                let status = json["IsSuccess"].stringValue
                if status == "true" {
                    var stylists:[Stylist] = []
                    let array = json["Results"].arrayValue
                    for item in array {
                        guard let dic = item.dictionaryObject else {continue}
                        if let stylist = Stylist(dic: dic) {
                            stylists.append(stylist)
                        }
                    }
                    completion(stylists)
                } else {
                    let errorMsg = json["ErrorMessage"].stringValue
                    if errorMsg == "invalid access token" {
                        DatabaseController.shared.logoutUser()
                        AppDelegate.shared().showLogin()
                    }
                    completion(nil)
                }
                
                
            case .failure(let error):
                let json = JSON(data: response.data!)
                print("ERROR LOADING EMPLOYEES: ", json)
                print("ERROR: ",error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func getEmployeesAsGuest(token: String,treatmentId:Int, completion: @escaping ([Stylist]?) -> Void) {

        let urlString = getBaseURL() + "employees"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            ]
        let params:Parameters = ["access_token":token, "LocationID" : 37514, "TreatmentID": treatmentId]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                print("SUCESS LOADING EMPLOYEES: ", json)
                let status = json["IsSuccess"].stringValue
                if status == "true" {
                    var stylists:[Stylist] = []
                    let array = json["Results"].arrayValue
                    for item in array {
                        guard let dic = item.dictionaryObject else {continue}
                        if let stylist = Stylist(dic: dic) {
                            stylists.append(stylist)
                        }
                    }
                    completion(stylists)
                } else {
                    let errorMsg = json["ErrorMessage"].stringValue
                    if errorMsg == "invalid access token" {
                        DatabaseController.shared.logoutUser()
                        AppDelegate.shared().showLogin()
                    }
                    completion(nil)
                }
                
                
            case .failure(let error):
                let json = JSON(data: response.data!)
                print("ERROR LOADING EMPLOYEES: ", json)
                print("ERROR: ",error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    //MARK: GET AVAILABLE TIMES
    /*********************************
     
     
     Content-Type: application/json; charset=utf-8
     POST https://apicurrent-app.booker.ninja/WebService4/json/CustomerService.svc/availability/multiservice
     {
     "EndDateTime": "/Date(1337223600000-0400)/",
     "Itineraries": [
     {
     "IsPackage": false,
     "PackageID": null,
     "Treatments": [
     {
     "Employee2ID": null,
     "EmployeeGenderID": null,
     "EmployeeID": 58125,
     "TreatmentID": 304032
     }
     ],
     "IncludeCutOffTimes": true
     }
     ],
     "LocationID": 3749,
     "MaxTimesPerDay": 5,
     "StartDateTime": "/Date(1337004000000-0400)/",
     "IsTreatmentFlexDuration": true,
     "ReturnAllSlots": true,
     "access_token": "3edb7157-1e34-4bf5-aa16-e18c1772042b"
     }
     **********************************/
    
    func getAvailableTimeslots(stylist: Stylist, service: Service, date: Date, completion: @escaping ([TimeSlot]?) -> Void) {
        guard let user = DatabaseController.shared.loadUser() else {
            completion(nil)
            return
        }
        let urlString = getBaseURL() + "availability/multiservice"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            ]
        
        var milliStart = date.startOfDay.timeIntervalSince1970
        milliStart = milliStart * 1000
        var milliEnd = date.endOfDay!.timeIntervalSince1970
        milliEnd = milliEnd * 1000
        let startDate = "/Date(\(Int(milliStart)))/"
        let endDate = "/Date(\(Int(milliEnd)))/"
        let employeeId = stylist.id!
        let treatmentId = service.id!
        let treatments = [["TreatmentID" : treatmentId, "EmployeeID":employeeId]]
        let itinerary = [["Treatments":treatments]]
        let params:Parameters = ["access_token":user.apiKey! , "LocationID" : 37514, "Itineraries":itinerary, "StartDateTime":startDate, "EndDateTime":endDate]
        dump(params)
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                print("SUCESS LOADING AVAILABLE TIMES: ", json)
                let status = json["IsSuccess"].stringValue
                if status == "true" {
                    var timeslots:[TimeSlot] = []
                    let array = json["ItineraryTimeSlotsLists"].arrayValue
                    guard let dicItem = array.first?.dictionary, let dicArray = dicItem["ItineraryTimeSlots"]?.arrayValue else {
                        completion(nil)
                        return
                    }
                    for item in dicArray {
                        let treatmentSlot = item["TreatmentTimeSlots"].arrayValue
                        guard let treatment = treatmentSlot.first?.dictionaryObject else {
                            completion(nil)
                            return
                        }
                        if let time = TimeSlot(dic: treatment) {
                            timeslots.append(time)
                        }
                    }
                    
                    completion(timeslots)
                } else {
                    let errorMsg = json["ErrorMessage"].stringValue
                    if errorMsg == "invalid access token" {
                        DatabaseController.shared.logoutUser()
                        AppDelegate.shared().showLogin()
                    }
                    completion(nil)
                }
                
                
            case .failure(let error):
                let json = JSON(data: response.data!)
                print("ERROR LOADING AVAILABLE TIMES: ", json)
                print("ERROR: ",error.localizedDescription)
                completion(nil)
            }
        }

    }
    
    func getAvailableTimeslotsAsGuest(stylist: Stylist, service: Service,token:String, date: Date, completion: @escaping ([TimeSlot]?) -> Void) {

        let urlString = getBaseURL() + "availability/multiservice"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            ]
        
        var milliStart = date.startOfDay.timeIntervalSince1970
        milliStart = milliStart * 1000
        var milliEnd = date.endOfDay!.timeIntervalSince1970
        milliEnd = milliEnd * 1000
        let startDate = "/Date(\(Int(milliStart)))/"
        let endDate = "/Date(\(Int(milliEnd)))/"
        let employeeId = stylist.id!
        let treatmentId = service.id!
        let treatments = [["TreatmentID" : treatmentId, "EmployeeID":employeeId]]
        let itinerary = [["Treatments":treatments]]
        let params:Parameters = ["access_token":token , "LocationID" : 37514, "Itineraries":itinerary, "StartDateTime":startDate, "EndDateTime":endDate]
        dump(params)
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                print("SUCESS LOADING AVAILABLE TIMES: ", json)
                let status = json["IsSuccess"].stringValue
                if status == "true" {
                    var timeslots:[TimeSlot] = []
                    let array = json["ItineraryTimeSlotsLists"].arrayValue
                    guard let dicItem = array.first?.dictionary, let dicArray = dicItem["ItineraryTimeSlots"]?.arrayValue else {
                        completion(nil)
                        return
                    }
                    for item in dicArray {
                        let treatmentSlot = item["TreatmentTimeSlots"].arrayValue
                        guard let treatment = treatmentSlot.first?.dictionaryObject else {
                            completion(nil)
                            return
                        }
                        if let time = TimeSlot(dic: treatment) {
                            timeslots.append(time)
                        }
                    }
                    
                    completion(timeslots)
                } else {
                    let errorMsg = json["ErrorMessage"].stringValue
                    if errorMsg == "invalid access token" {
                        DatabaseController.shared.logoutUser()
                        AppDelegate.shared().showLogin()
                    }
                    completion(nil)
                }
                
                
            case .failure(let error):
                let json = JSON(data: response.data!)
                print("ERROR LOADING AVAILABLE TIMES: ", json)
                print("ERROR: ",error.localizedDescription)
                completion(nil)
            }
        }
        
    }
    
    //MARK: FORGOT PASSWORD
    
    /**************************
     Content-Type: application/json; charset=utf-8
     POST https://apicurrent-app.booker.ninja/WebService4/json/CustomerService.svc/forgot_password
     {
     "Email": "testcustomer@booker.com",
     "Firstname": "Test",
     "LocationID": 3749,
     "BrandID": null,
     "access_token": "66282713-c82c-4159-ab2a-63629d62f83d"
     }
    ***************************/
    
    func forgotPassword(email: String,token: String,name: String, completion: @escaping (Bool) -> Void) {
        let urlString = getBaseURL() + "forgot_password"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            ]
        let params:Parameters = ["Email" : email, "Firstname":name, "LocationID" : 37514, "access_token": token]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                print("SUCESS FORGOT PASSWORD: ", json)
                let status = json["IsSuccess"].stringValue
                if status == "true" {
                    completion(true)
                } else {
                    completion(false)
                }
                
            case .failure(let error):
                let json = JSON(data: response.data!)
                print("ERROR FORGOT PASSWORD: ", json)
                print("ERROR: ",error.localizedDescription)
                completion(false)
            }
        }
    }
    
    //MARK: UPDATE USER DATA
    
    /***********************
     Content-Type: application/json; charset=utf-8
     PUT https://apicurrent-app.booker.ninja/WebService4/json/CustomerService.svc/customer/{CustomerID}
     {
     "Address": {
     "City": "New York",
     "Country": {
     "ID": 1,
     "Name": ""
     ....}}
     **************************/
    
    func updateUser(with id: Int, firstName: String,lastName: String, email: String,number: String, token: String, completion: @escaping (Bool) -> Void) {
        let urlString = getBaseURL() + "customer/\(id)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            ]
        let params:Parameters = ["CustomerID": id, "Email" : email, "FirstName":firstName, "LocationID" : 37514,"HomePhone" : number,"LastName":lastName, "access_token": token]
        Alamofire.request(urlString, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                print("SUCESS UPDATE USER DATA: ", json)
                let status = json["IsSuccess"].stringValue
                if status == "true" {
                    completion(true)
                } else {
                    completion(false)
                }
                
            case .failure(let error):
                let json = JSON(data: response.data!)
                print("ERROR UPDATE USER DATA: ", json)
                print("ERROR: ",error.localizedDescription)
                completion(false)
            }
        }
    }
    
    //MARK: Confirm Appointment
    
    /***************************
     Content-Type: application/json; charset=utf-8
     POST https://apicurrent-app.booker.ninja/WebService4/json/CustomerService.svc/appointment/create
     {
     *****************************/
    
    func confirmAppointment(appointment: Appointment, user: User,card: CreditCard, completion: @escaping (Bool) -> Void) {
        let urlString = getBaseURL() + "appointment/create"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            ]
        
        let amount:[String:Any] = ["Amount":appointment.service.price ?? 0, "CurrencyCode" : "USD"]
        let cardType:[String:Any] = ["ID":card.typeID,"Name":card.type]
        let creditCard:[String:Any] = ["BillingZip" : card.zipCode, "ExpirationDate" : card.expirationDateString,"NameOnCard":card.name,"Number":card.numbers,"SecurityCode":card.cvv,"Type":cardType]
        dump(creditCard)
        let method:[String:Any] = ["ID": 1, "Name": "method"]
        let paymentItem = ["Amount":amount,"CreditCard":creditCard, "Method":method]
        let appPayment:[String:Any] = ["PaymentItem":paymentItem, "CouponCode":""]
        let customer:[String:Any] = ["FirstName": user.firstName, "LastName":user.lastName,"HomePhone":user.phoneNumber, "MobilePhone":"", "Email":user.email]
        
        //treatment time slots
        let treatment:[String:Any] = ["CurrentPrice":amount,"EmployeeID" : appointment.stylist.id, "StartDateTime" : appointment.timeslot.startDateTime!,"TreatmentID":appointment.service.id!,"EmployeeWasRequested":true]
        let treatmentTimeSlots = [treatment]
        
        let itinerary:[String:Any] = ["StartDateTime":appointment.timeslot.startDateTime!, "TreatmentTimeSlots":treatmentTimeSlots, "IsPackage":false, "CurrentPackagePrice" : amount]
        
        let params:Parameters = ["ItineraryTimeSlotList":[itinerary],"AppointmentPayment":appPayment, "Customer":customer, "LocationID" : 37514, "access_token": user.apiKey!]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                print("SUCESS CONFIRM APP: ", json)
                let status = json["IsSuccess"].stringValue
                if status == "true" {
                    completion(true)
                } else {
                    completion(false)
                }
                
            case .failure(let error):
                let json = JSON(data: response.data!)
                print("ERROR CONFIRM APP: ", json)
                print("ERROR: ",error.localizedDescription)
                completion(false)
            }
        }
    }
    
    
    //MARK: GET UPCOMING APPOINTMENTS
    
    func getUpcomingAppointments(completion: @escaping ([UpcomingAppointment]?) -> Void) {
        guard let user = DatabaseController.shared.loadUser(), let customerID = user.customerId, let token = user.apiKey else {
            completion(nil)
            return
        }
        let urlString = getBaseURL() + "customer/\(customerID)/appointments?access_token=\(token)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            ]
        
        Alamofire.request(urlString, method: .get, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                print("SUCESS LOADING UPCOMING APPOINTMENTS: ", json)
                let status = json["IsSuccess"].stringValue
                if status == "true" {
                    var appointments:[UpcomingAppointment] = []
                    let apps = json["Appointments"].arrayValue
                    for item in apps {
                        guard let dic = item.dictionaryObject, let startTime = dic["StartDateTime"] as? String, let endTime = dic["EndDateTime"] as? String, let treatment = dic["Treatment"] as? [String: Any], let service = treatment["Name"] as? String else {
                            print("failed to parse")
                            continue
                        }
                        
                        guard let appTreamtDic = item["AppointmentTreatments"].arrayObject else {continue}
                        
                        guard let appTreamt = appTreamtDic[0] as? [String: Any] else {continue}
                        
                        guard let employee = appTreamt["Employee"] as? [String:Any] else {continue}
                        guard let firstName = employee["FirstName"] as? String else {continue}
                        guard let lastName = employee["LastName"] as? String else {continue}
                        
                        
                        let upcoming = UpcomingAppointment(startDateTime: startTime, endDateTime: endTime, service: service, firstName: firstName, lastName: lastName)
                        print(upcoming)
                        appointments.append(upcoming)
                        
                    }
                    print(appointments)
                    completion(appointments)
                } else {
                    let errorMsg = json["ErrorMessage"].stringValue
                    if errorMsg.contain("you are not authorized to peform this action.") {
                        DatabaseController.shared.logoutUser()
                        AppDelegate.shared().showLogin()
                    }
                    completion(nil)
                }
                
                
            case .failure(let error):
                let json = JSON(data: response.data!)
                print("ERROR LOADING UPCOMING APPOINTMENTS: ", json)
                print("ERROR: ",error.localizedDescription)
            
            }
        }
    }
}
