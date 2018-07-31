//
//  DateExtensions.swift
//  SegurosMtyiOS
//
//  Created by Rafael Jimeno Osornio on 12/6/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation

extension Date {
    
    func localDate(format: String) -> String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = format
        
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.locale = Locale(identifier: "es_MX")
        let date = dateFormatter.string(from: self)
        
        return date
    }
    
    func shortDate() -> String {
        return self.localDate(format: "dd/MM/yyyy")
    }
    
    func shortMonthDate() -> String {
        return self.localDate(format: "dd / MMM / yyyy").capitalized
    }
    
    func monthYear() -> String{
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "es_MX")
        return dateFormatter.string(from: self)
    }

    func longDate() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.locale = Locale(identifier: "en_US")
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    func addYears(_ yearsToAdd: Int) -> Date {
        return self.addDays(yearsToAdd * 365)
    }
    
    func addDays(_ daysToAdd: Int) -> Date {
        return self.addHours(daysToAdd * 24)
    }
    
    func addHours(_ hoursToAdd: Int) -> Date {
        return self.addMinutes(hoursToAdd * 60)
    }
    
    func addMinutes(_ minutesToAdd: Int) -> Date {
        let timeInterval: TimeInterval = Double(minutesToAdd) * 60
        let newDate: Date = self.addingTimeInterval(timeInterval)
        
        return newDate
    }
}
