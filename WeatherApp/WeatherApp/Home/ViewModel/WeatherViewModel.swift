//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Sunil Kumar Reddy Sanepalli on 26/05/23.
//

import Foundation
import Combine

import Combine
class WeatherViewModel {
    
    @Published var locationsList = [LocationModel]()
    
    @Published var weatherDetails: WeatherDetailsModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    func getLocationsList(locationName: String, limit: Int) {
        //let url = UrlsList.baseUrl + geo/1.0/direct?q={city name},{state code},{country code}&limit={limit}&appid={API key}
        
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
    
    func getWeatherDetails(lat: Double, lon: Double) {
        //https://api.openweathermap.org/data/2.5/weather?lat=17.360589&lon=78.4740613&appid=89d9a480b9f397238b588ebf17a41e84
        
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
