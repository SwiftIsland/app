//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import CoreLocation

final class LocationManager: NSObject, ObservableObject {
    @Published var currentAuthorizationStatus: CLAuthorizationStatus?

    private let coreLocationManager: CLLocationManager
    private var requestAuthorizationContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var requestLocationContinuation: CheckedContinuation<CLLocationCoordinate2D?, Error>?

    init(coreLocationManager: CLLocationManager = CLLocationManager()) {
        self.coreLocationManager = coreLocationManager

        super.init()

        coreLocationManager.delegate = self
        currentAuthorizationStatus = coreLocationManager.authorizationStatus
    }

    /// Requests the user’s permission to use location services while the app is in use.
    /// - Returns: Constants indicating the app's authorization to use location services.
    func requestAuthorization() async -> CLAuthorizationStatus {
        await withCheckedContinuation { continuation in
            requestAuthorizationContinuation = continuation
            coreLocationManager.requestWhenInUseAuthorization()
        }
    }

    /// Requests the one-time delivery of the user’s current location.
    /// - Returns: The latitude and longitude associated with a location, if recieved
    func requestLocation() async throws -> CLLocationCoordinate2D? {
        try await withCheckedThrowingContinuation { continuation in
            requestLocationContinuation = continuation
            coreLocationManager.requestLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        requestLocationContinuation?.resume(returning: locations.first?.coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        requestLocationContinuation?.resume(throwing: error)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        currentAuthorizationStatus = manager.authorizationStatus
        requestAuthorizationContinuation?.resume(returning: manager.authorizationStatus)
    }
}
