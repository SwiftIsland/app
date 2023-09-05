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
        let status = await withCheckedContinuation { continuation in
            requestAuthorizationContinuation = continuation
            coreLocationManager.requestWhenInUseAuthorization()
        }
        requestAuthorizationContinuation = nil
        return status
    }

    /// Requests the one-time delivery of the user’s current location.
    /// - Returns: The latitude and longitude associated with a location, if recieved
    func requestLocation() async throws -> CLLocationCoordinate2D? {
        let location = try await withCheckedThrowingContinuation { continuation in
            requestLocationContinuation = continuation
            coreLocationManager.requestLocation()
        }
        requestLocationContinuation = nil
        return location
    }

    /// Determines if the given coordinates lie within the boundaries of Texel in the Netherlands or Ingarö in Stockholm.
    ///
    /// This function checks if the given `CLLocationCoordinate2D` parameter lies within the defined boundaries for the islands of Texel or Ingarö (For testing by Paul Peelen).
    ///
    /// - Parameter coordinate: The `CLLocationCoordinate2D` value representing a location's latitude and longitude.
    /// - Returns: A `Bool` indicating whether the given coordinates lie within the boundaries of Texel or Ingarö. Returns `true` if they do, `false` otherwise.
    /// - Note: The boundaries defined in this function are approximations and may not exactly match the geographical boundaries of the islands.
    /// - Warning: For more precise results, consider using a more detailed geographical model or library that can handle complex polygon shapes.
    func isCoordinateInTexel(_ coordinate: CLLocationCoordinate2D) -> Bool {
        let texelMin = CLLocationCoordinate2D(latitude: 52.9797199311885, longitude: 4.650365369448815)
        let texelMax = CLLocationCoordinate2D(latitude: 53.19324793605265, longitude: 4.966470908970561)

        let ingaroMin = CLLocationCoordinate2D(latitude: 59.27564, longitude: 18.43983)
        let ingaroMax = CLLocationCoordinate2D(latitude: 59.2844, longitude: 18.460)

        let isCoordinateInTexel = coordinate.latitude >= texelMin.latitude &&
            coordinate.latitude <= texelMax.latitude &&
            coordinate.longitude >= texelMin.longitude &&
            coordinate.longitude <= texelMax.longitude

        let isCoordinateInIngaro = coordinate.latitude >= ingaroMin.latitude &&
            coordinate.latitude <= ingaroMax.latitude &&
            coordinate.longitude >= ingaroMin.longitude &&
            coordinate.longitude <= ingaroMax.longitude

        return isCoordinateInTexel || isCoordinateInIngaro
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
