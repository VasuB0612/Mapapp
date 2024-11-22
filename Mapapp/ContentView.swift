import SwiftUI
import MapKit
import CoreLocation

struct SavedLocation: Codable {
    var latitude: Double
    var longitude: Double
    var title: String
}

import UIKit
import MapKit
import CoreLocation

class ContentViewController: UIViewController, MKMapViewDelegate, SavedLocationsDelegate {
    var mapView: MKMapView!
    var locationManager: LocationManager
    var userLocation: CLLocation?
    
    private let savedLocationsKey = "savedLocations"

    // Initialize the LocationManager
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.locationManager = LocationManager()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize map view
        mapView = MKMapView(frame: self.view.frame)
        mapView.delegate = self
        mapView.showsUserLocation = true // Show the blue dot for user location
        self.view.addSubview(mapView)

        // Load and display saved annotations
        loadSavedAnnotations()

        // Start location updates
        locationManager.locationUpdateHandler = { [weak self] location in
            self?.userLocation = location
            self?.centerMapOnUserLocation() // Keep map centered on user location
        }
        locationManager.startLocationUpdates()
        
        // Add a tap gesture to add a custom location
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        // Create the "Locate Me" button (Airplane Button)
        let airplaneButton = UIButton(type: .system)
        let airplaneImage = UIImage(systemName: "location.fill")?.withTintColor(.systemBlue, renderingMode: .alwaysTemplate)
        airplaneButton.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        airplaneButton.layer.cornerRadius = 10
        airplaneButton.setImage(airplaneImage, for: .normal)
        airplaneButton.translatesAutoresizingMaskIntoConstraints = false
        airplaneButton.addTarget(self, action: #selector(didTapAirplaneButton), for: .touchUpInside)
        self.view.addSubview(airplaneButton)
        
        // Add Auto Layout constraints for the airplane button
        NSLayoutConstraint.activate([
            airplaneButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            airplaneButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            airplaneButton.widthAnchor.constraint(equalToConstant: 50),
            airplaneButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let showSavedLocationsButton = UIButton(type: .system)
        showSavedLocationsButton.setTitle("Show Saved", for: .normal)
        showSavedLocationsButton.translatesAutoresizingMaskIntoConstraints = false
        showSavedLocationsButton.addTarget(self, action: #selector(didTapShowSavedLocationsButton), for: .touchUpInside)
        self.view.addSubview(showSavedLocationsButton)

        // Set the background color to white with a bit of transparency
        showSavedLocationsButton.backgroundColor = UIColor.white.withAlphaComponent(0.8)  // 80% opacity

        // Set the corner radius to make the button rounded
        showSavedLocationsButton.layer.cornerRadius = 10
        showSavedLocationsButton.layer.masksToBounds = true
        
        // Add Auto Layout constraints for the button
        NSLayoutConstraint.activate([
            showSavedLocationsButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            showSavedLocationsButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            showSavedLocationsButton.widthAnchor.constraint(equalToConstant: 150),
            showSavedLocationsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // A button to reset the stored locations.
        let clearAllButton = UIButton(type: .system)
        clearAllButton.setTitle("Clear All", for: .normal)
        clearAllButton.translatesAutoresizingMaskIntoConstraints = false
        clearAllButton.addTarget(self, action: #selector(didTapClearAllButton), for: .touchUpInside)
        self.view.addSubview(clearAllButton)

        // Set the background color to white with a bit of transparency
        clearAllButton.backgroundColor = UIColor.white.withAlphaComponent(0.8)  // Red for danger

        // Set the corner radius to make the button rounded
        clearAllButton.layer.cornerRadius = 10
        clearAllButton.layer.masksToBounds = true

        // Add Auto Layout constraints for the button
        NSLayoutConstraint.activate([
            clearAllButton.bottomAnchor.constraint(equalTo: showSavedLocationsButton.topAnchor, constant: -10),
            clearAllButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            clearAllButton.widthAnchor.constraint(equalToConstant: 150),
            clearAllButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func didTapClearAllButton() {
            UserDefaults.standard.removeObject(forKey: savedLocationsKey)
            mapView.removeAnnotations(mapView.annotations)
            
            print("All saved locations cleared.")
        }
    
    @objc func didTapShowSavedLocationsButton() {
        let savedLocationsVC = SavedLocationsViewController()
        savedLocationsVC.delegate = self // Set delegate to self (ContentViewController)
        let navigationController = UINavigationController(rootViewController: savedLocationsVC)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - SavedLocationsDelegate
    func didSelectLocation(_ location: SavedLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    func loadSavedAnnotations() {
        if let savedLocations = loadLocations() {
            for location in savedLocations {
                let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = location.title
                mapView.addAnnotation(annotation)
            }
        }
    }

    func loadLocations() -> [SavedLocation]? {
        if let savedData = UserDefaults.standard.data(forKey: savedLocationsKey) {
            let decoder = JSONDecoder()
            if let loadedLocations = try? decoder.decode([SavedLocation].self, from: savedData) {
                return loadedLocations
            }
        }
        return [] // Return an empty array instead of nil
    }

    func saveLocations(locations: [SavedLocation]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(locations) {
            UserDefaults.standard.set(encoded, forKey: savedLocationsKey)
        }
    }

    @objc func didTapAirplaneButton() {
        guard let location = userLocation else {
            print("User location is unavailable")
            return
        }

        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }

    func centerMapOnUserLocation() {
        guard let location = userLocation else { return }

        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }

    @objc func didTapMap(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(in: mapView)
        let mapCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        showNameLocationAlert(at: mapCoordinate)
    }

    func showNameLocationAlert(at coordinate: CLLocationCoordinate2D) {
        let alertController = UIAlertController(title: "Name this Location", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter location name"
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let name = alertController.textFields?.first?.text, !name.isEmpty {
                self.addAnnotation(at: coordinate, withName: name)
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
    }

    func addAnnotation(at coordinate: CLLocationCoordinate2D, withName name: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        mapView.addAnnotation(annotation)

        // Create the SavedLocation object
        let newLocation = SavedLocation(latitude: coordinate.latitude, longitude: coordinate.longitude, title: name)
        
        // Load existing locations
        var savedLocations = loadLocations() ?? []
        
        // Append the new location
        savedLocations.append(newLocation)
        
        // Save to UserDefaults
        saveLocations(locations: savedLocations)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin") ??
                MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")

            if let pinAnnotationView = annotationView as? MKPinAnnotationView {
                pinAnnotationView.canShowCallout = true
                pinAnnotationView.pinTintColor = UIColor.blue
            }

            return annotationView
        }
        return nil
    }
}
