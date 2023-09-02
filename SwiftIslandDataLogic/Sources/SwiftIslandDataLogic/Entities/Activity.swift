//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

/// An Activity is something a participant can join. This can be a workshop or an action. An activity can contain mentors or it can be without any.
///
/// - Parameters:
///   - id: The ID of the activity
///   - title: Activity title
///   - description: Activity description
///   - mentors: The ID's of the mentors for the activity. Can be an empty array if not Mentors are assigned
///   - type: The `ActivityType` of the activity
///   - duration: The duration of the activity in seconds
public struct Activity: Response {
    public let id: String
    public let title: String
    public let description: String
    public let mentors: [String]
    public let type: ActivityType
    public let duration: Double
}

extension Activity: Identifiable { }

extension Activity: Hashable { }

public extension Activity {
    /// Only meant to be used for Preview purposes. Might change in the future.
    /// - Parameters:
    ///   - id: The ID of the activity
    ///   - title: Activity title
    ///   - description: Activity description
    ///   - mentors: The ID's of the mentors for the activity. Can be an empty array if no Mentors are assigned
    ///   - type: The ``ActivityType`` of the activity
    ///   - duration: The duration of the activity in seconds
    /// - Returns: `Activity`
    static func forPreview(id: String = "1",
                           title: String = "Lorum Ipsum",
                           description: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vestibulum maximus quam, eget egestas nisi accumsan eget. Phasellus egestas tristique tortor, vel interdum lorem porta non.",
                           mentors: [String] = [],
                           type: ActivityType = .workshop,
                           duration: Double = 60 * 60) -> Activity {
        Activity(id: id,
                 title: title,
                 description: description,
                 mentors: mentors,
                 type: type,
                 duration: duration)
    }
}

/// Defines the type of the `Activity`.
public enum ActivityType: String, Codable, CaseIterable {
    /// A workshop type of event. Usually has mentors
    case workshop = "Workshop"

    /// A social activity, often optional. E.g. Game or cycling
    case socialActivity = "Social"

    /// A meal. E.g. breakfast, lunch, dinner
    case meal = "Meal"

    /// An activity a participant must perform
    case mandatoryEventActivity = "Mandatory event activity"

    /// An activity related to transportation
    case transport = "Transport"

    /// An activity only for those that have received an invitation
    case inviteOnly = "Invite only activity"
}
