import SwiftUI
import MapKit

struct MapView: View {
    @Binding var position: MapCameraPosition
    @Binding var selectedLocations: [Location]
    @Binding var selectedCoordinate: CLLocationCoordinate2D?

    var body: some View {
        // Use Map with the `MapCameraPosition` parameter
        Map(position: $position, annotationItems: selectedLocations) { location in
            // Use MapAnnotation to create custom annotations
            MapAnnotation(coordinate: location.coordinate) {
                // Customize the annotation with any SwiftUI view (e.g., an Image or Text)
                VStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(location.name)
                        .font(.caption)
                }
            }
        }
        .mapControls {
            // Add map controls like user location button and pitch toggle
            MapUserLocationButton()
            MapPitchToggle()
        }
        .onTapGesture {
            // Capture the coordinates of the tap location
            if let selectedCoordinate = self.selectedCoordinate {
                print("User tapped at: \(selectedCoordinate.latitude), \(selectedCoordinate.longitude)")
            }
        }
    }
}
