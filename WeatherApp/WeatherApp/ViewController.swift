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
    
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var imageCloud: UIImageView!
    @IBOutlet weak var labelFeel: UILabel!
    
    let locationManager = CLLocationManager()
    
    private let viewModel = WeatherViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    let userDefaults = UserDefaults.standard


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let isLocation = userDefaults.string(forKey: "isLocation"), isLocation == "yes" {
            print(userDefaults.double(forKey: "latitude"))
            print(userDefaults.double(forKey: "longitude"))
                getWeatherDetails(lat: userDefaults.double(forKey: "latitude"), lon: userDefaults.double(forKey: "longitude"))
        }
        else {
            getUserLocation()
        }
        bindViewModel()
    }
    
    func bindViewModel() {
        
        viewModel.$weatherDetails.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                //print("data...\(self?.viewModel.weatherDetails?.main.pressure ?? 0)")
                if let details = self?.viewModel.weatherDetails?.main.temp {
                    self?.updateData()
                }
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
            let trimmedString = (searchLocationTextfield.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            getLocationDetails(searchString: trimmedString)
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
    
    func updateData()  {
        labelDate.text = "\(dateConvertion(date: Date(timeIntervalSince1970: Double(viewModel.weatherDetails?.dt ?? 0))))"
        labelName.text = "\(viewModel.weatherDetails?.name ?? ""), \(viewModel.weatherDetails?.sys.country ?? "")"
        //labelTemp.text = "\(Int(viewModel.weatherDetails?.main.temp ?? 0.0))" + "°" + "C"
        labelTemp.text = "\(Int(viewModel.weatherDetails?.main.tempMin ?? 0.0))" + "°" + "C"
        let feelsData = "\(Int(viewModel.weatherDetails?.main.feelsLike ?? 0.0))" + "°" + "C"
        var info = ""
        if let infoData = viewModel.weatherDetails?.weather, infoData.count > 0 {
            info = "\(infoData.first?.main ?? "")" + "."
        }
        labelFeel.text = "Feels like \(feelsData). \(info)"
        saveSearchedLocation()
    }
    
    func saveSearchedLocation() {
        userDefaults.set("yes", forKey: "isLocation")
        userDefaults.set(viewModel.weatherDetails?.coord.lat ?? 0.0, forKey: "latitude")
        userDefaults.set(viewModel.weatherDetails?.coord.lon ?? 0.0, forKey: "longitude")
        userDefaults.synchronize()
    }
    
    func dateConvertion(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, HH:mm a"
        return formatter.string(from: Date.now)
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

extension ViewController: LocationSelectionDelegate {
    func locationSelection(row: Int, details: LocationModel?) {
        //searchLocationTextfield.text = ""
        if let longitude = details?.lon, let latitude = details?.lat {
            self.getWeatherDetails(lat: latitude, lon: longitude)
        }
    }
}

