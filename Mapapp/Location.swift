// Location.swift
import Foundation
import CoreLocation

struct Location: Identifiable {
    var id = UUID()  // Conforms to Identifiable
    var name: String
    var coordinate: CLLocationCoordinate2D
}

