//
//  ContentView.swift
//  Mapapp
//
//  Created by Vasu Bhatnagar on 9.10.2024.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        Map{
            
        }.onAppear{
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
}

#Preview {
    ContentView()
}
