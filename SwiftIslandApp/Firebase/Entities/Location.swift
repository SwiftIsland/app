//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import FirebaseFirestoreSwift

enum LocationError: Error {
    case parsingErrorDataNotFound
}

struct Location: Response {
    let id: String
    let title: String
    let coordinate: CLLocationCoordinate2D

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)

        let coordinates = try container.decode([String: Double].self, forKey: .coordinate)
        guard let latitude = coordinates["latitude"], let longitude = coordinates["longitude"] else {
            throw LocationError.parsingErrorDataNotFound
        }

        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    internal init(id: String, title: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.title = title
        self.coordinate = coordinate
    }

    static func forPreview(id: String = "1", title: String = "Lorum Ipsum", coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 53.11486048459769, longitude: 4.897194963296373)) -> Location {
        Location(id: id, title: title, coordinate: coordinate)
    }
}

extension Location: Identifiable { }

extension CLLocationCoordinate2D: Codable {
     public func encode(to encoder: Encoder) throws {
         var container = encoder.unkeyedContainer()
         try container.encode(longitude)
         try container.encode(latitude)
     }

     public init(from decoder: Decoder) throws {
         var container = try decoder.unkeyedContainer()
         let longitude = try container.decode(CLLocationDegrees.self)
         let latitude = try container.decode(CLLocationDegrees.self)
         self.init(latitude: latitude, longitude: longitude)
     }
 }
