//
//  ContentView.swift
//  Mapapp
//
//  Created by Vasu Bhatnagar on 9.10.2024.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var selectedLocations: [Location] = []
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var locationName: String = ""

    var body: some View {
        VStack{
            MapView(position: $position, selectedLocations: $selectedLocations, selectedCoordinate: $selectedCoordinate)
            if let selectedCoordinate = selectedCoordinate {
                LocationNameInputView(locationName: $locationName) {
                    saveLocation(name: locationName, coordinate: selectedCoordinate)
                }
            }
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
    func saveLocation(name: String, coordinate: CLLocationCoordinate2D) {
        // Create a new Location object and add it to the list of selected locations
        let newLocation = Location(name: name, coordinate: coordinate)
        selectedLocations.append(newLocation)
        
        // Reset the input field
        locationName = ""
    }
}

#Preview {
    ContentView()
}
