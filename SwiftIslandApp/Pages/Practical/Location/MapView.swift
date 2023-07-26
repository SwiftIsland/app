//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject private var appDataModel: AppDataModel

    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 53.11478763673313,
                                                                                  longitude: 4.8972633598615065),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                                          longitudeDelta: 0.01))

    @State private var locations: [Location] = []

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: locations) { location in
            MapAnnotation(coordinate: location.coordinate) {
                PlaceAnnotationView(title: location.title)
            }
        }
        .onAppear {
            Task {
                if !isPreview {
                    let locations = await appDataModel.fetchLocations()

                    self.locations = locations
                } else {
                    self.locations = [
                        Location.forPreview()
                    ]
                }
            }
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
