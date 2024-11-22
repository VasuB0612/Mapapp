//
//  SavedLocationsViewController.swift
//  Mapapp
//
//  Created by Vasu Bhatnagar on 22.11.2024.
//

import UIKit

// Add a protocol to notify the selection event
protocol SavedLocationsDelegate: AnyObject {
    func didSelectLocation(_ location: SavedLocation)
}

class SavedLocationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var savedLocations: [SavedLocation] = []
    weak var delegate: SavedLocationsDelegate?  // Delegate reference to notify selection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: self.view.bounds)
        tableView.dataSource = self
        tableView.delegate = self // Set the delegate to handle selection
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LocationCell")
        self.view.addSubview(tableView)
        
        if let locations = loadLocations() {
            savedLocations = locations
        }
        
        self.title = "Saved Locations"
    }

    func loadLocations() -> [SavedLocation]? {
        if let savedData = UserDefaults.standard.data(forKey: "savedLocations") {
            let decoder = JSONDecoder()
            if let loadedLocations = try? decoder.decode([SavedLocation].self, from: savedData) {
                return loadedLocations
            }
        }
        return [] // Return an empty array if no data is found
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let location = savedLocations[indexPath.row]
        cell.textLabel?.text = location.title // Display only the name
        return cell
    }

    // Handle the row selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = savedLocations[indexPath.row]
        delegate?.didSelectLocation(selectedLocation) // Notify delegate
        self.dismiss(animated: true, completion: nil) // Dismiss the view controller after selection
    }
}

