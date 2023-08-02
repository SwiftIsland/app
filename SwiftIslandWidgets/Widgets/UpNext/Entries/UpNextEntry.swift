//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import WidgetKit
import SwiftIslandDataLogic

struct UpNextEntry: TimelineEntry {
    let date: Date
    let event: Event?

    static func forPreview() -> UpNextEntry {
        UpNextEntry(date: .now, event: Event.forPreview(startDate: Date(timeIntervalSinceNow: 37 * 60), activity: Activity.forPreview(title: "Amazing workshop", type: .workshop, duration: 120 * 60)))
    }

    static func forPlaceholder() -> UpNextEntry {
        UpNextEntry(date: .now, event: Event.forPreview(startDate: Date(timeIntervalSinceNow: 37 * 60), activity: Activity.forPreview(title: "Amazing workshop", type: .workshop, duration: 120 * 60)))
    }

    static func noMoreEvents() -> UpNextEntry {
        UpNextEntry(date: .now, event: nil)
    }
}
