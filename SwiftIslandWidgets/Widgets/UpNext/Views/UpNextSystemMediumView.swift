//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import WidgetKit
import SwiftIslandDataLogic

struct UpNextSystemMediumView: View {
    var entry: UpNextProvider.Entry

    var body: some View {
        ZStack {
            LinearGradient.defaultBackground
            if let event = entry.event {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(event.activity.type.rawValue)
                            .font(.caption)
                            .foregroundColor(event.activity.type.color)
                            .fontWeight(.light)
                        HStack {
                            Circle()
                                .fill(event.activity.type.color)
                                .frame(width: 7)
                            Text(event.activity.title)
                                .font(.title)
                        }
                        .padding(.bottom, 8)
                        Text(event.activity.description)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                            .padding(.bottom, 8)
                        Spacer()
                        HStack {
                            Text(event.startDate.formatted())
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(event.startDate.relativeDateDisplay())
                                .font(.caption)
                        }
                    }
                    .padding()
                }
                .dynamicTypeSize(DynamicTypeSize.small ... DynamicTypeSize.xLarge)
            } else {
                if entry.isTooFarInTheFuture {
                    VStack(alignment: .center) {
                        Text("Up Next")
                            .font(.body)
                        Text("Sure, _early bird gets the worm_, but you are a little too early 😉\n\nCheck back here a few days before the event.")
                            .font(.footnote)
                            .fontWeight(.light)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                } else {
                    VStack(alignment: .center) {
                        Image("Logo")
                            .resizable()
                            .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                            .frame(width: 36)
                            .shadow(color: .primary.opacity(0.2), radius: 10, x: 0, y: 0)
                        Text("Swift Island is over ;(\nSee you again next year?")
                            .font(.footnote)
                            .fontWeight(.light)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
            }
        }
    }
}

struct UpNextSystemMedium_Previews: PreviewProvider {
    static var previews: some View {
        UpNextSystemMediumView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .preferredColorScheme(.light)
            .previewDisplayName("Medium light")

        UpNextSystemMediumView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .preferredColorScheme(.dark)
            .previewDisplayName("Medium dark")

        UpNextSystemMediumView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .preferredColorScheme(.dark)
            .dynamicTypeSize(.xxxLarge)
            .previewDisplayName("Medium dark xxxLarge font")

        UpNextSystemMediumView(entry: UpNextEntry.isTooFarAhead())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .preferredColorScheme(.light)
            .previewDisplayName("Too early light")

        UpNextSystemMediumView(entry: UpNextEntry.isTooFarAhead())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .preferredColorScheme(.dark)
            .previewDisplayName("Too early dark")

        UpNextSystemMediumView(entry: UpNextEntry.noMoreEvents())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .preferredColorScheme(.light)
            .previewDisplayName("No more events light")

        UpNextSystemMediumView(entry: UpNextEntry.noMoreEvents())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .preferredColorScheme(.dark)
            .previewDisplayName("No more events dark")
    }
}
