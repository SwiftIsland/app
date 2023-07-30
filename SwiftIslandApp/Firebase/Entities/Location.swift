//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

enum LocationError: Error {
    case parsingErrorDataNotFound
}

struct Location: Response {
    let id: String
    let title: String
    let type: LocationType
    let coordinate: CLLocationCoordinate2D

    enum CodingKeys: CodingKey {
        case id, title, coordinate, type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        let type = try container.decode(String.self, forKey: .type)
        self.type = LocationType(rawValue: type) ?? .unknown
        
        let coordinates = try container.decode([String: Double].self, forKey: .coordinate)
        guard let latitude = coordinates["latitude"], let longitude = coordinates["longitude"] else {
            throw LocationError.parsingErrorDataNotFound
        }
        
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    internal init(id: String, title: String, type: LocationType, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.title = title
        self.coordinate = coordinate
        self.type = type
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.type.rawValue, forKey: .type)

        let coordinates = ["latitude": coordinate.latitude, "longitude": coordinate.longitude]
        try container.encode(coordinates, forKey: .coordinate)
    }
    
    static func forPreview(id: String = "1",
                           title: String = "Lorum Ipsum",
                           type: LocationType = .unknown,
                           coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 53.11486048459769,
                                                                                       longitude: 4.897194963296373)) -> Location {
        Location(id: id, title: title, type: type, coordinate: coordinate)
    }
}

extension Location: Identifiable { }

extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}

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

enum LocationType: String, CaseIterable, Identifiable {
    case venue
    case restaurant
    case poi
    case bungalow
    case workshopRoom
    case restroom
    case parking
    case unknown

    var id: String { self.rawValue }

    var color: Color {
        switch self {
        case .venue:
            return  .yellow
        case .restaurant:
            return  .green
        case .poi:
            return  .pink
        case .bungalow:
            return .brown
        case .workshopRoom:
            return .gray
        case .restroom:
            return .cyan
        case .parking:
            return .blue
        case .unknown:
            return .white
        }
    }

    var title: String {
        switch self {
        case .venue:
            return "Venue"
        case .restaurant:
            return "Restaurant"
        case .poi:
            return "Point Of Interest"
        case .bungalow:
            return "Bungalow"
        case .workshopRoom:
            return "Workshop location"
        case .restroom:
            return "Restroom & amenities"
        case .parking:
            return "Parking"
        case .unknown:
            return "Unknown type"
        }
    }

    var icon: Image {
        switch self {
        case .restaurant:
            return Image(systemName: "fork.knife.circle.fill")
        case .poi:
            return Image(systemName: "binoculars.fill")
        case .restroom:
            return Image(systemName: "toilet.circle.fill")
        case .venue:
            return Image(systemName: "info.circle.fill")
        case .bungalow:
            return Image(systemName: "house.and.flag.circle.fill")
        case .workshopRoom:
            return Image(systemName: "graduationcap.circle.fill")
        case .parking:
            return Image(systemName: "parkingsign.circle.fill")
        default:
            return Image(systemName: "mappin.circle.fill")
        }
    }
}
