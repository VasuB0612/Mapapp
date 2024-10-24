//
//  Location.swift
//  Mapapp
//
//  Created by Vasu Bhatnagar on 24.10.2024.
//

import Foundation
import CoreLocation

struct Location: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    var name: String
}
