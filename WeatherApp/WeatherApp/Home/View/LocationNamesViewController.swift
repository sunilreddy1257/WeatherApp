//
//  LocationNamesViewController.swift
//  WeatherApp
//
//  Created by Sunil Kumar Reddy Sanepalli on 26/05/23.
//

import UIKit

//@usage -> Send selected city details to viewcontroller
protocol LocationSelectionDelegate: AnyObject {
    func locationSelection(details: List?)
}

class LocationNamesViewController: UIViewController {
    
    var locationNames:[List]? {
        didSet {
            calculateAndSetPreferredContentSize()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: LocationSelectionDelegate?
    let locationNameCell = "LocationNameCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //Based on number of citys contentsize will be calculated
    func calculateAndSetPreferredContentSize() {
        let totalItems = CGFloat(locationNames?.count ?? 0)
            let totalHeight = totalItems * 55
        preferredContentSize = CGSize(width: self.view.frame.size.width, height: totalHeight)
        }

}
//MARK: Tableview Delegate and DataSource Methods
extension LocationNamesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationNames?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: locationNameCell) as? LocationNameCell {
            let locationData = locationNames?[indexPath.row]
            cell.textLabel?.text = "\(locationData?.name ?? ""), \(locationData?.sys?.country ?? "")"
            //print("\(locationData?.name ?? "")")
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.locationSelection(details: locationNames?[indexPath.row])
        self.dismiss(animated: true)
    }
}
