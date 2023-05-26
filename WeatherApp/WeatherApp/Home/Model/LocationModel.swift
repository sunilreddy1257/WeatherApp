//
//  LocationModel.swift
//  WeatherApp
//
//  Created by Sunil Kumar Reddy Sanepalli on 25/05/23.
//

import Foundation

struct LocationModel: Decodable {
    let message: String
    let cod: String
    let count: Int
    let list: [List]
}

struct List: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let main: Main
    let dt: Int?
    let wind: Wind?
    let sys: Sys?
    let rain: Rain?
    let snow: Snow?
    let clouds: Clouds?
    let weather: [Weather]?
}
struct Rain: Codable {
    let value: String?
}
struct Snow: Codable {
    let value: String?
}

