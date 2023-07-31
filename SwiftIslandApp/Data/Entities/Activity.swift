//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct Activity: Response {
    let id: String
    let title: String
    let description: String
    let mentors: [String]
    let type: ActivityType
    let imageName: String?
    let duration: Double
}

extension Activity: Identifiable { }

extension Activity: Hashable { }

extension Activity {
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

enum ActivityType: String, Codable, CaseIterable {
    case workshop = "Workshop"
    case socialActivity = "Social"
    case meal = "Meal"
    case mandatoryEventActivity = "Mandatory event activity"
    case transport = "Transport"
    case inviteOnly = "Invite only activity"

    var color: Color {
        switch self {
        case .workshop:
            return .purple
        case .socialActivity:
            return .yellowDark
        case .meal:
            return .green
        case .mandatoryEventActivity:
            return .redDark
        case .transport:
            return .orangeDark
        case .inviteOnly:
            return .purple
        }
    }
}
