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
    @State private var locations: [Location] = []
    @State private var selectedCoordinate: CLLocationCoordinate2D?

    var body: some View {
        VStack {
            MapView(position: $position, locations: $locations, selectedCoordinate: $selectedCoordinate)
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
}

#Preview {
    ContentView()
}
