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

    init(dbEvent: DBEvent, activity: Activity) {
        self.id = dbEvent.id
        self.startDate = dbEvent.startDate
        self.endDate = dbEvent.startDate.addingTimeInterval(activity.duration)
        self.duration = activity.duration
        self.activity = activity
    }
}
