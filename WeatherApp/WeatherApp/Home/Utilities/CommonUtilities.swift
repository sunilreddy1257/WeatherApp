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
        return formatter.string(from: Date.now)
    }
}
