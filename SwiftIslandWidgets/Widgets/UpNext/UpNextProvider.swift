//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import WidgetKit
import SwiftUI
import SwiftIslandDataLogic

struct UpNextProvider: TimelineProvider {

    let dataLogic = SwiftIslandDataLogic()

    init() {
        SwiftIslandDataLogic.configure()
    }

    func getSnapshot(in context: Context, completion: @escaping (UpNextEntry) -> Void) {
        completion(UpNextEntry.forPreview())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<UpNextEntry>) -> Void) {
        Task {
            let events = await dataLogic.fetchEvents()
            let futureEvents = events.filter { $0.startDate > Date() }

            var entries: [UpNextEntry] = []

            if futureEvents.count > 0 {
                futureEvents.forEach { event in
                    entries.append(Entry(date: event.startDate, event: event))
                }
            } else {
                entries.append(Entry(date: .now, event: nil))
            }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }

    func placeholder(in context: Context) -> UpNextEntry {
        UpNextEntry.forPlaceholder()
    }
}
