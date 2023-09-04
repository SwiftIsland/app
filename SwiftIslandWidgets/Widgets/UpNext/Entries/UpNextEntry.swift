//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import WidgetKit
import SwiftIslandDataLogic

struct UpNextEntry: TimelineEntry {
    let date: Date
    let event: Event?
    let isTooFarInTheFuture: Bool

    static func forPreview() -> UpNextEntry {
        UpNextEntry(date: .now, event: Event.forPreview(startDate: Date(timeIntervalSinceNow: 37 * 60), activity: Activity.forPreview(title: "Amazing workshop", description: "This mentor will blow your mind. Be ready for some amazing workshopping.", type: .workshop, duration: 120 * 60)), isTooFarInTheFuture: false)
    }

    static func forPlaceholder() -> UpNextEntry {
        UpNextEntry(date: .now, event: Event.forPreview(startDate: Date(timeIntervalSinceNow: 37 * 60), activity: Activity.forPreview(title: "Amazing workshop", description: "This mentor will blow your mind. Be ready for some amazing workshopping.", type: .workshop, duration: 120 * 60)), isTooFarInTheFuture: false)
    }

    static func noMoreEvents() -> UpNextEntry {
        UpNextEntry(date: .now, event: nil, isTooFarInTheFuture: false)
    }

    static func isTooFarAhead() -> UpNextEntry {
        UpNextEntry(date: .now, event: nil, isTooFarInTheFuture: true)
    }
}
