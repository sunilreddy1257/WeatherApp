//
//  CommonUtilities.swift
//  WeatherApp
//
//  Created by Sunil Kumar Reddy Sanepalli on 26/05/23.
//

import Foundation


class CommonUtilities {
    static let shared = CommonUtilities()
    private init() {}
    
    //@usage: Date conversion
    func dateConvertion(date: Date, dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat//"MMM dd, HH:mm a"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.string(from: date)
    }
    
    func convertDate(givenDate: Double) -> Date {
        let date = Date(timeIntervalSince1970: givenDate)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let localDate = dateFormatter.string(from: date)
        let dateCon = dateFormatter.date(from: localDate) ?? Date()
        return dateCon
    }
    
    func getTimezone(timezone: Int) -> Int {
        timezone/60
    }
    
    func timeDifference(date: Double, diff: Int) -> String {
        let firstTime = convertDate(givenDate: date)
        let timeDiff = getTimezone(timezone: diff)
        let modifiedDate = Calendar.current.date(byAdding: .minute, value: timeDiff, to: firstTime) ?? Date()
        let actualDate = dateConvertion(date: modifiedDate, dateFormat: AllData.dateFormat)
        return actualDate
    }
}
