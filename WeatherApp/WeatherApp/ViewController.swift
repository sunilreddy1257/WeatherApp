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
    @IBOutlet weak var searchLocationTextfield: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    let locationManager = CLLocationManager()
    
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
        
        
        viewModel.$locationsList.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                if let listData = self?.viewModel.locationsList, listData.count > 0 {
                    self?.showLocationNames(names: listData)
                }
            }
            .store(in: &self.cancellables)
    }

    func getUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func getWeatherDetails(lat: Double, lon: Double) {
        viewModel.getWeatherDetails(lat: lat, lon: lon)
    }
    
    func getLocationDetails(searchString: String) {
        viewModel.getLocationsList(locationName: searchString)
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        if searchLocationTextfield.text?.count ?? 0 > 0 {
            searchLocationTextfield.resignFirstResponder()
            viewModel.locationsList.removeAll()
            getLocationDetails(searchString: searchLocationTextfield.text ?? "")
        }
    }
    
    func showLocationNames(names: [LocationModel]) {
        guard let locationsVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationNamesViewController") as? LocationNamesViewController else { return }
        locationsVc.locationNames = names
        locationsVc.modalPresentationStyle = .popover
        locationsVc.delegate = self
        let buttonFrame = searchLocationTextfield?.frame ?? CGRect.zero
        if let popoverPresentationController = locationsVc.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = buttonFrame
            popoverPresentationController.delegate = self
            present(locationsVc, animated: true, completion: nil)
        }
    }

}

//MARK: CLLocationManager Delegate Methods
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.getWeatherDetails(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
}

extension ViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ViewController: LocationNamesDelegate {
    func locationSelection(row: Int, details: LocationModel?) {
        //searchLocationTextfield.text = ""
        if let longitude = details?.lon, let latitude = details?.lat {
            self.getWeatherDetails(lat: latitude, lon: longitude)
        }
    }
}

