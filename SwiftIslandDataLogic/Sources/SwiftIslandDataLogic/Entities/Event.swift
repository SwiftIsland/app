//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

/// An event is an scheduled activity.
///
/// - Parameters:
///   - id: The ID of the event
///   - startDate: The start time of the event as `Date`
///   - endDate: The end time of the event as `Date`
///   - activity: The ``activity`` bound to the event
///   - duration: The duration of the event in seconds.
public struct Event {
    public let id: String
    public let startDate: Date
    public let endDate: Date
    public let activity: Activity
    public let duration: TimeInterval

    public var coordinates: CGRect?
    public var column: Int = 0
    public var columnCount: Int = 0

    internal init(dbEvent: DBEvent, activity: Activity) {
        self.id = dbEvent.id
        self.startDate = dbEvent.startDate
        self.endDate = dbEvent.startDate.addingTimeInterval(activity.duration)
        self.duration = activity.duration
        self.activity = activity
    }
}

extension Event: Identifiable { }

extension Event: Equatable { }

extension Event {
    /// Only meant to be used for Preview purposes. Might change in the future.
    ///
    /// - Parameters:
    ///   - id: The ID of the event
    ///   - startDate: The start time of the event as `Date`
    ///   - endDate: The end time of the event as `Date`
    ///   - activity: The ``activity`` bound to the event
    ///   - duration: The duration of the event in seconds.
    /// - Returns: an ``Event``
    public static func forPreview(id: String = "1",
                           startDate: Date = Date(timeIntervalSinceNow: 60 * 60),
                           endDate: Date = Date(timeIntervalSinceNow: (60 * 60) * 2),
                           activity: Activity = Activity.forPreview(),
                           duration: TimeInterval = 60 * 60) -> Event {
        Event(id: id, startDate: startDate, endDate: endDate, activity: activity, duration: duration)
    }

    internal init(id: String, startDate: Date, endDate: Date, activity: Activity, duration: TimeInterval, coordinates: CGRect? = nil, column: Int = 0, columnCount: Int = 0) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.activity = activity
        self.duration = duration
        self.coordinates = coordinates
        self.column = column
        self.columnCount = columnCount
    }
}
