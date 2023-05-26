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
        if let isLocation = userDefaults.string(forKey: UserdefaultsKeys.isLocation), isLocation == "yes" {
                getWeatherDetails(lat: userDefaults.double(forKey: UserdefaultsKeys.latitude), lon: userDefaults.double(forKey: UserdefaultsKeys.longitude))
        }
        else {
            getUserLocation()
        }
        
        bindViewModel()
    }
    
    //@usage: creating subscribers for @published property wrappers - weatherDetails, locationsList
    func bindViewModel() {
        
        viewModel.$weatherDetails.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
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
//@usage: Initially request for user permission for accessing the users location
    func getUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    //@usage: based on latitude and longitude we are calling weather details api
    func getWeatherDetails(lat: Double, lon: Double) {
        viewModel.getWeatherDetails(lat: lat, lon: lon)
    }
    //@usage: based searched string, calling locations api
    func getLocationDetails(searchString: String) {
        viewModel.getLocationsList(locationName: searchString)
    }
    
    //@usage: tap on Search icon we can call the api for location details
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        if searchLocationTextfield.text?.count ?? 0 > 0 {
            searchLocationTextfield.resignFirstResponder()
            viewModel.locationsList.removeAll()
            let trimmedString = (searchLocationTextfield.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            getLocationDetails(searchString: trimmedString)
        }
    }
    
    //@usage: Showing serached locations
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
    
    //@usage: Once get the weather details we can update the data
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
    
    //@usage: Save updated serached location details
    func saveSearchedLocation() {
        userDefaults.set("yes", forKey: UserdefaultsKeys.isLocation)
        userDefaults.set(viewModel.weatherDetails?.coord.lat ?? 0.0, forKey: UserdefaultsKeys.latitude)
        userDefaults.set(viewModel.weatherDetails?.coord.lon ?? 0.0, forKey: UserdefaultsKeys.longitude)
        userDefaults.synchronize()
    }
    
    //@usage: Date conversion
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

//MARK: Textfield Delegate Method
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: LocationSelectionDelegate
extension ViewController: LocationSelectionDelegate {
    func locationSelection(row: Int, details: LocationModel?) {
        //searchLocationTextfield.text = ""
        if let longitude = details?.lon, let latitude = details?.lat {
            self.getWeatherDetails(lat: latitude, lon: longitude)
        }
    }
}

