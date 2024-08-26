//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import MapKit

struct GettingThereMapView: View {
    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 53.11478763673313,
            longitude: 4.8972633598615065
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.5,
            longitudeDelta: 0.5
        )
    ))

    let locations: [GettingThereLocation]

    var body: some View {
        Map(position: $cameraPosition) {
            Marker(coordinate: CLLocationCoordinate2D(
                latitude: 53.11478763673313,
                longitude: 4.8972633598615065
            )) { }
        }
        .ignoresSafeArea()
    }
}

struct GettingThereMapView_Previews: PreviewProvider {
    static var previews: some View {
        let location = GettingThereLocation(coordinate: CLLocationCoordinate2D(latitude: 53.11478763673313, longitude: 4.8972633598615065))

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

struct GettingThereLocation {
    let coordinate: CLLocationCoordinate2D
}

extension GettingThereLocation: Identifiable {
    var id: String {
        "\(coordinate.latitude):\(coordinate.longitude)"
    }
}
