//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Sunil Kumar Reddy Sanepalli on 26/05/23.
//

import Foundation
import Combine

class WeatherViewModel {
    
    @Published var locationsList = [LocationModel]()
    @Published var weatherDetails: WeatherDetailsModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    /*Name: getLocationsList
     Params: locationName: String -> This will be City/State, limit: Int
     @usage: based on location we are getting the list of locations.
     */
    func getLocationsList(locationName: String, limit: Int = 5) {
        let url = UrlsList.baseUrl + "geo/1.0/direct?q=\(locationName)&limit=\(limit)&appid=\(UrlsList.apiKey)"
        WeatherService.shared.getLocationNames(url: url, type: LocationModel.self)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: {[weak self] locationsList in
                self?.locationsList = locationsList
            }
            .store(in: &self.cancellables)
    }
    
    /*Name: getWeatherDetails
     Params: lat: Double, lon: Double -> These values getting from current location Co-ordinates or from searched location
     @usage: getting the weather details - temp, feeling like etc
     */
    func getWeatherDetails(lat: Double, lon: Double) {
        let url = UrlsList.baseUrl + "data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(UrlsList.apiKey)"
        WeatherService.shared.getWeatherDetails(url: url, type: WeatherDetailsModel.self)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: {[weak self] weatherDetails in
                self?.weatherDetails = weatherDetails
            }
            .store(in: &self.cancellables)
    }
}
