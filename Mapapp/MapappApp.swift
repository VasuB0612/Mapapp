    //
    //  MapappApp.swift
    //  Mapapp
    //
    //  Created by Vasu Bhatnagar on 9.10.2024.
    //

    import SwiftUI

    @main
    struct MapappApp: App {
        var body: some Scene {
            WindowGroup {
                // Use the MapView representable to show your UIKit-based map view
                MapView() // This uses your UIViewControllerRepresentable wrapper
            }
        }
    }

