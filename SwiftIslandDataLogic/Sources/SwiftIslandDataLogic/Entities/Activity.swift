//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

public struct Activity: Response {
    public let id: String
    public let title: String
    public let description: String
    public let mentors: [String]
    public let type: ActivityType
    public let imageName: String?
    public let duration: Double
}

extension Activity: Identifiable { }

extension Activity: Hashable { }

public extension Activity {
    static func forPreview(id: String = "1",
                           title: String = "Lorum Ipsum",
                           description: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vestibulum maximus quam, eget egestas nisi accumsan eget. Phasellus egestas tristique tortor, vel interdum lorem porta non.",
                           mentors: [String] = [],
                           type: ActivityType = .workshop,
                           imageName: String? = nil,
                           duration: Double = 60 * 60) -> Activity {
        Activity(id: id,
                 title: title,
                 description: description,
                 mentors: mentors,
                 type: type,
                 imageName: imageName,
                 duration: duration)
    }
}

public enum ActivityType: String, Codable, CaseIterable {
    case workshop = "Workshop"
    case socialActivity = "Social"
    case meal = "Meal"
    case mandatoryEventActivity = "Mandatory event activity"
    case transport = "Transport"
    case inviteOnly = "Invite only activity"
}
