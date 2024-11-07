import SwiftUI
import MapKit
import CoreLocation

class ContentViewController: UIViewController, MKMapViewDelegate {
    var mapView: MKMapView!
    var locationManager: LocationManager
    var userLocation: CLLocation?

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
        self.view.addSubview(mapView)
        
        // Start location updates
        locationManager.locationUpdateHandler = { [weak self] location in
            self?.userLocation = location
            self?.centerMapOnUserLocation()
        }
        locationManager.startLocationUpdates()
        
        // Add a tap gesture to add a custom location
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        // Create the "Locate Me" button
        let locateMeButton = UIButton(type: .system)
        locateMeButton.setTitle("Locate Me", for: .normal)
        locateMeButton.translatesAutoresizingMaskIntoConstraints = false  // Enable Auto Layout
        locateMeButton.addTarget(self, action: #selector(didTapLocateMeButton), for: .touchUpInside)
        self.view.addSubview(locateMeButton)
        
        locateMeButton.backgroundColor = .white
        locateMeButton.layer.cornerRadius = 10
        
        // Add Auto Layout constraints for the button
        NSLayoutConstraint.activate([
            locateMeButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            locateMeButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            locateMeButton.widthAnchor.constraint(equalToConstant: 100),
            locateMeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func didTapLocateMeButton() {
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

struct ContentView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ContentViewController {
        // Create LocationManager instance
        let locationManager = LocationManager()
        
        // Create and return the ContentViewController with LocationManager
        return ContentViewController(locationManager: locationManager)
    }
    
    func updateUIViewController(_ uiViewController: ContentViewController, context: Context) {
        // No need to update the view controller in this case
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 12") // Optional: Set the preview device
    }
}
