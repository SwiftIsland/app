//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct UpNextWidget: Widget {
    let kind = "SwiftIslandUpNextWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: UpNextProvider()) { entry in
            UpNextEntryView(entry: entry)
        }
        .configurationDisplayName("Up Next")
        .description("The next event at the conference.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            // Add Support to Lock Screen widgets
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline ])
    }
}
