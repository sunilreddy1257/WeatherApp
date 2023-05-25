//
//  LocationNamesViewController.swift
//  WeatherApp
//
//  Created by Sunil Kumar Reddy Sanepalli on 26/05/23.
//

import UIKit

protocol LocationNamesDelegate: AnyObject {
    func locationSelection(row: Int, details: LocationModel?)
}

class LocationNamesViewController: UIViewController {
    
    var locationNames:[LocationModel]? {
        didSet {
            calculateAndSetPreferredContentSize()
            print("Called")
        }
    }
    let locationNameCell = "LocationNameCell"

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: LocationNamesDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //tableView.register(LocationNameCell.self, forCellReuseIdentifier: locationNameCell)
    }
    func calculateAndSetPreferredContentSize() {
        let totalItems = CGFloat(locationNames?.count ?? 0)
            let totalHeight = totalItems * 55
        preferredContentSize = CGSize(width: self.view.frame.size.width, height: totalHeight)
        }

}

extension LocationNamesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationNames?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationNameCell") as? LocationNameCell {
            let locationData = locationNames?[indexPath.row]
            cell.textLabel?.text = "\(locationData?.name ?? ""),\(locationData?.country ?? "")"
            print("\(locationData?.name ?? "")")
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.locationSelection(row: indexPath.row, details: locationNames?[indexPath.row])
        self.dismiss(animated: true)
    }
}
