//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

struct Event {
    let id: String
    let startDate: Date
    let endDate: Date
    let activity: Activity
    let duration: TimeInterval

    var coordinates: CGRect?
    var column: Int = 0
    var columnCount: Int = 0

    init(dbEvent: DBEvent, activity: Activity) {
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
    static func forPreview(id: String = "1",
                           startDate: Date = Date(timeIntervalSinceNow: 60*60),
                           endDate: Date = Date(timeIntervalSinceNow: (60*60)*2),
                           activity: Activity = Activity.forPreview(),
                           duration: TimeInterval = 60*60) -> Event {
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
