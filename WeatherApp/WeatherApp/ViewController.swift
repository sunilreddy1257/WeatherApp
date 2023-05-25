//
//  ViewController.swift
//  WeatherApp
//
//  Created by Sunil Kumar Reddy Sanepalli on 25/05/23.
//

import UIKit
import MapKit
import Combine

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    private let viewModel = WeatherViewModel()
    
    private var cancellables = Set<AnyCancellable>()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getUserLocation()
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.$weatherDetails.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("data...\(self?.viewModel.weatherDetails?.main.pressure ?? 0)")
            }
            .store(in: &self.cancellables)
    }

    func getUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func getWeatherDetails(location: CLLocationCoordinate2D) {
        viewModel.getWeatherDetails(lat: location.latitude, lon: location.longitude)
    }

}

//MARK: CLLocationManager Delegate Methods
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        //currentLocation = location.coordinate
        self.getWeatherDetails(location: location.coordinate)
        locationManager.stopUpdatingLocation()
    }
}

