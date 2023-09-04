//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import WidgetKit
import SwiftUI
// import TobbeHelpers

struct UpNextEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: UpNextProvider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            UpNextSystemSmallView(entry: entry)
        case .systemMedium:
            UpNextSystemMediumView(entry: entry)
        case .systemLarge:
            UpNextSystemLargeView(entry: entry)
        case .accessoryInline:
            if let event = entry.event {
                Text("🦭 \(event.activity.title)")
            } else {
                Text("🦭 What's next?")
            }
        case .accessoryCircular:
            UpNextSystemCircularView()
        case .accessoryRectangular:
            UpNextSystemRectangularView(entry: entry)
        default:
            Text("No support for requested size")
        }
    }
}

struct UpNextEntryView_Previews: PreviewProvider {
    static var previews: some View {
        UpNextEntryView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
            .previewDisplayName("Inline")
        UpNextEntryView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .previewDisplayName("Circular")
        UpNextEntryView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .previewDisplayName("Rectangular")
        UpNextEntryView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small")
        UpNextEntryView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("System medium")
        UpNextEntryView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .previewDisplayName("System large")
    }
}
