//
//  LocationModel.swift
//  WeatherApp
//
//  Created by Sunil Kumar Reddy Sanepalli on 25/05/23.
//

import Foundation

struct LocationModel: Codable {

    let name: String
    let localNames: LocalNames?
    let lat: Double
    let lon: Double
    let country: String
    let state: String

}

struct LocalNames: Codable {

    let ka: String?
    let ml: String?
    let eo: String?

}
