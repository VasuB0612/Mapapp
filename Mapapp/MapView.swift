//
//  MapView.swift
//  Mapapp
//
//  Created by Vasu Bhatnagar on 24.10.2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var position: MapCameraPosition
    @Binding var locations: [Location]
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    
    var body: some View{
        Map(position: $position, annotationItems: locations) { location in
            MapPin(coordinate: location.coordinate, tint: .blue)
        }
        .mapControls {
            MapUserLocationButton()
            MapPitchToggle()
        }
        .onTapGesture { location in
            selectedCoordinate = location.coordinate
            showAlertForLocationName()
        }
    }
    
    private func showAlertForLocationName() {
        let alert = UIAlertController(title: "Location Name", message: "Enter a name for this location", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Location name"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            if let textField = alert.textFields?.first, let name = textField.text, let coordinate = selectedCoordinate {
                let newLocation = Location(coordinate: coordinate, name: name)
                locations.append(newLocation)
                selectedCoordinate = nil
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
}
