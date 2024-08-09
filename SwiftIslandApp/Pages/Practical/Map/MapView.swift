//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import MapKit
import SwiftIslandDataLogic

struct MapView: View {
    @EnvironmentObject private var appDataModel: AppDataModel

    @State private var showFilterPopover = false
    @State private var locationTypes: [LocationTypeSelection] = []
    @State private var filteredLocation: [Location] = []

    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 53.11478763673313,
            longitude: 4.8972633598615065
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
    ))

    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(filteredLocation) { location in
                Annotation("", coordinate: location.coordinate) {
                    PlaceAnnotationView(location: location)
                }
            }
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.showFilterPopover.toggle()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.questionMarkColor)
                        .popover(
                            isPresented: $showFilterPopover,
                            attachmentAnchor: .point(.bottom),
                            arrowEdge: .top
                        ) {
                            VStack(alignment: .leading) {
                                Text("Select types to show")
                                    .foregroundColor(.secondary)
                                    .dynamicTypeSize(DynamicTypeSize.small ... DynamicTypeSize.medium)
                                ForEach($locationTypes) { $locationType in
                                    HStack {
                                        Circle()
                                            .fill(locationType.locationType.color)
                                            .frame(width: 7)
                                        Text(locationType.locationType.title)
                                        Spacer()
                                        Toggle(locationType.id, isOn: $locationType.isSelected)
                                            .labelsHidden()
                                    }
                                }
                            }
                            .foregroundColor(.primary)
                            .padding()
                            .presentationCompactAdaptation(.popover)
                        }
                }
            }
        }
        .onAppear {
            filteredLocation = appDataModel.locations
            filterTypes()
        }
        .onChange(of: appDataModel.locations) { _, _ in
            filterTypes()
        }
        .onChange(of: locationTypes) { _, _ in
            let selectedTypes = locationTypes.filter { $0.isSelected }.map { $0.locationType }
            filteredLocation = appDataModel.locations.filter { selectedTypes.contains($0.type) }
        }
        .task {
            if !isPreview {
                await appDataModel.fetchLocations()
            }
        }
    }

    func filterTypes() {
        self.locationTypes = appDataModel.locations.map { $0.type }.unique().map { LocationTypeSelection(locationType: $0, isSelected: true) }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let appDataModel = AppDataModel()

        let locations = [
            Location.forPreview(id: "0", title: "End or minor street", type: .venue, coordinate: CLLocationCoordinate2D(latitude: 53.114887, longitude: 4.897275)),
            Location.forPreview(id: "1", title: "Bungalow", type: .bungalow, coordinate: CLLocationCoordinate2D(latitude: 53.114039, longitude: 4.896798)),
            Location.forPreview(id: "2", title: "Far away bathroom, good luck!", type: .restroom, coordinate: CLLocationCoordinate2D(latitude: 53.114564, longitude: 4.896030)),
            Location.forPreview(id: "3", title: "Lots of water", type: .poi, coordinate: CLLocationCoordinate2D(latitude: 53.115704, longitude: 4.900839)),
            Location.forPreview(id: "4", title: "Second bathroom", type: .restroom, coordinate: CLLocationCoordinate2D(latitude: 53.114941, longitude: 4.897107)),
            Location.forPreview(id: "5", title: "Restaurant", type: .restaurant, coordinate: CLLocationCoordinate2D(latitude: 53.114767, longitude: 4.897045))
        ]
        appDataModel.locations = locations

        return NavigationStack {
            MapView()
                .environmentObject(appDataModel)
        }
    }
}

private struct LocationTypeSelection: Identifiable, Equatable {
    var id: String { locationType.id }

    let locationType: LocationType
    var isSelected = false
}

private extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
