//
//  UpcomingAppointment.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2017-08-16.
//  Copyright © 2017 com.bomane. All rights reserved.
//

import Foundation

struct UpcomingAppointment {
    var service:String!
    var date:Date!
    var time:String!
    var stylist:String!

}

extension UpcomingAppointment {
    init(startDateTime: String, endDateTime: String, service: String, firstName: String, lastName: String) {
        
        var dateString = startDateTime.replacingOccurrences(of: "Date", with: "")
        dateString = dateString.replacingOccurrences(of: "/", with: "")
        dateString = dateString.replacingOccurrences(of: "(", with: "")
        dateString = dateString.replacingOccurrences(of: ")", with: "")
        let endIndex = dateString.index(dateString.endIndex, offsetBy: -5)
        let truncated = dateString.substring(to: endIndex)
        
        if let dateInt = Int(truncated) {
            let secondsInt = dateInt/1000
            //print("DATE: \(secondsInt)")
            self.date = Date(timeIntervalSince1970: Double(secondsInt))
            
            
        }
        
        var secondDate:Date = Date()
        var endDateString = endDateTime.replacingOccurrences(of: "Date", with: "")
        endDateString = endDateString.replacingOccurrences(of: "/", with: "")
        endDateString = endDateString.replacingOccurrences(of: "(", with: "")
        endDateString = endDateString.replacingOccurrences(of: ")", with: "")
        let endDateIndex = endDateString.index(endDateString.endIndex, offsetBy: -5)
        let truncated2 = endDateString.substring(to: endDateIndex)
        
        if let dateInt2 = Int(truncated2) {
            let secondsInt2 = dateInt2/1000
            //print("DATE: \(secondsInt2)")
            secondDate = Date(timeIntervalSince1970: Double(secondsInt2))
            
        }
        
        self.time = self.date.timeString(ofStyle: .short).lowercased() + " - " + secondDate.timeString(ofStyle: .short).lowercased()
        
        self.stylist = firstName.lowercased().capitalized + " " + lastName.lowercased().capitalized
        
        self.service = service.lowercased().capitalized
    }
}
