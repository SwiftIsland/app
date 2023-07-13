//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import MapKit

struct GettingThereMapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 53.11478763673313,
                                                                                  longitude: 4.8972633598615065),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.5,
                                                                          longitudeDelta: 0.5))

    let locations: [Location]

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: locations) {
            MapMarker(coordinate: $0.coordinate)
        }
            .ignoresSafeArea()
    }
}

struct GettingThereMapView_Previews: PreviewProvider {
    static var previews: some View {
        let location = Location(coordinate: CLLocationCoordinate2D(latitude: 53.11478763673313, longitude: 4.8972633598615065))

        Group {
            GettingThereMapView(locations: [location])
                .preferredColorScheme(.light)
                .previewDisplayName("Light mode")
            GettingThereMapView(locations: [location])
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}

struct Location {
    let coordinate: CLLocationCoordinate2D
}

extension Location: Identifiable {
    var id: String {
        "\(coordinate.latitude):\(coordinate.longitude)"
    }
}
