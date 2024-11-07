//
//  MapView.swift
//  Mapapp
//
//  Created by Vasu Bhatnagar on 7.11.2024.
//

import SwiftUI
import MapKit

// 1. Define the MapView that conforms to UIViewControllerRepresentable
struct MapView: UIViewControllerRepresentable {
    
    // 2. Create and return the ContentViewController in the makeUIViewController method
    func makeUIViewController(context: Context) -> ContentViewController {
        // Return an instance of your ContentViewController (not ContentView which is a SwiftUI View)
        let locationManager = LocationManager()
        
        return ContentViewController(locationManager: locationManager)
    }
    
    // 3. Implement updateUIViewController (no changes needed in this case)
    func updateUIViewController(_ uiViewController: ContentViewController, context: Context) {
        // Handle updates to your view controller if needed
    }
}


