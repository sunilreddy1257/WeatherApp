//
//  WeatherDetailsModel.swift
//  WeatherApp
//
//  Created by Sunil Kumar Reddy Sanepalli on 25/05/23.
//

import Foundation

struct WeatherDetailsModel: Codable {

    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int

}
struct Coord: Codable {

    let lon: Double
    let lat: Double

}

struct Weather: Codable {

    let id: Int
    let main: String
    let description: String?
    let icon: String

}

struct Main: Codable {

    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let humidity: Int?
    
    enum CodingKeys: String, CodingKey {
            
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }

}

struct Wind: Codable {

    let speed: Double?
    let deg: Int?

}

struct Clouds: Codable {

    let all: Int?

}

struct Sys: Codable {

    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?

}
