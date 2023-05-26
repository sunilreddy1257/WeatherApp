//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Sunil Kumar Reddy Sanepalli on 26/05/23.
//

import Foundation
import Combine

protocol WeatherViewModelProtocol {
    var locationsList: [List] {set get}
    var weatherDetails: WeatherDetailsModel? {set get}
    func getLocationsList(locationName: String, limit: Int)
    func getWeatherDetails(lat: Double, lon: Double)
}

class WeatherViewModel: WeatherViewModelProtocol {
    
    @Published var locationsList = [List]()
    @Published var weatherDetails: WeatherDetailsModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    /*Name: getLocationsList
     Params: locationName: String -> This will be City/State, limit: Int
     @usage: based on location we are getting the list of locations.
     */
    func getLocationsList(locationName: String, limit: Int = 5) {
        let url = UrlsList.baseUrl + "data/2.5/find?q=\(locationName)&limit=\(limit)&appid=\(AllData.apiKey)&units=metric"
        WeatherService.shared.getDetails(url: url, type: LocationModel.self)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: {[weak self] locationsList in
                self?.locationsList = locationsList.list
            }
            .store(in: &self.cancellables)
    }
    
    /*Name: getWeatherDetails
     Params: lat: Double, lon: Double -> These values getting from current location Co-ordinates or from searched location
     @usage: getting the weather details - temp, feeling like etc
     */
    func getWeatherDetails(lat: Double, lon: Double) {
        let url = UrlsList.baseUrl + "data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(AllData.apiKey)"
        print("Weather details api call...\(url)")
        WeatherService.shared.getDetails(url: url, type: WeatherDetailsModel.self)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: {[weak self] weatherDetails in
                print(weatherDetails.coord)
                self?.weatherDetails = weatherDetails
            }
            .store(in: &self.cancellables)
    }
    
    func getFormatDate() -> String {
        return CommonUtilities.shared.dateConvertion(date: Date(timeIntervalSince1970: Double(self.weatherDetails?.dt ?? 0)), dateFormat: AllData.dateFormat)
    }
    
    func getLocationDetails() -> String {
        return "\(self.weatherDetails?.name ?? ""), \(self.weatherDetails?.sys.country ?? "")"
    }
    
    func getTempMin() -> String {
        return "\(Int(self.weatherDetails?.main.tempMin ?? 0.0))"
    }
    
    func getFeelLike() -> String {
        return "\(Int(self.weatherDetails?.main.feelsLike ?? 0.0))"
    }
}
