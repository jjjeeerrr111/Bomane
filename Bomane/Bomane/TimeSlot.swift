//
//  TimeSlot.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2017-01-26.
//  Copyright © 2017 com.bomane. All rights reserved.
//

import Foundation

struct TimeSlot {
    var treatmentId: Int?
    var employeeId: Int?
    var duraton:Int?
    var startDateTime:String?
    var startDate:Date?
    var isSelected = false
    
    init?(dic: [String:Any]) {
        guard let empID = dic["EmployeeID"] as? Int, let treatId = dic["TreatmentID"] as? Int, let startString = dic["StartDateTime"] as? String, let dur = dic["Duration"] as? Int  else {return nil}
        
        self.treatmentId = treatId
        self.employeeId = empID
        self.duraton = dur
        self.startDateTime = startString
        
        var dateString = startString.replacingOccurrences(of: "Date", with: "")
        dateString = dateString.replacingOccurrences(of: "/", with: "")
        dateString = dateString.replacingOccurrences(of: "(", with: "")
        dateString = dateString.replacingOccurrences(of: ")", with: "")
        dateString = dateString.replacingOccurrences(of: "-0500", with: "")
        
        if let dateInt = Int(dateString) {
            let secondsInt = dateInt/1000
            
            self.startDate = Date(timeIntervalSince1970: Double(secondsInt))
            
        }
        
    }
}
