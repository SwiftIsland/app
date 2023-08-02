//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import WidgetKit
import SwiftUI
//import TobbeHelpers

struct UpNextEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: UpNextProvider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            UpNextSystemSmallView(entry: entry)
        case .systemMedium:
            UpNextSystemMediumView(entry: entry)
        case .accessoryInline:
            if let event = entry.event {
                Text("Next event \(event.startDate.relativeDateDisplay())")
            } else {
                Text("No more events.")
            }
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
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small")
        UpNextEntryView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("System medium")
    }
}

