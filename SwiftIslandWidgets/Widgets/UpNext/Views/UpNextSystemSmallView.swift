//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import WidgetKit
import SwiftIslandDataLogic

struct UpNextSystemSmallView: View {
    var entry: UpNextProvider.Entry

    var body: some View {
        ZStack {
            LinearGradient.defaultBackground
            if let event = entry.event {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Circle()
                                .fill(event.activity.type.color)
                                .frame(width: 5)
                            Text(event.activity.type.rawValue)
                                .font(.caption)
                                .foregroundColor(event.activity.type.color)
                                .fontWeight(.light)
                        }
                        Text(event.activity.title)
                            .font(.title)
                            .minimumScaleFactor(0.5)
                            .padding(.bottom, 2)
                        Text(event.activity.description)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                            .padding(.bottom, 8)
                            .minimumScaleFactor(0.8)
                        Spacer()
                        Text(event.startDate.relativeDateDisplay())
                            .font(.caption)
                            .foregroundColor(.secondary)
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
                            .shadow(color: .primary.opacity(0.2), radius: 5, x: 0, y: 0)
                            .padding(.top, 8)
                        Text("Swift Island is over ;(\nSee you again next year?")
                            .font(.footnote)
                            .fontWeight(.light)
                            .multilineTextAlignment(.center)
                            .dynamicTypeSize(DynamicTypeSize.small ... DynamicTypeSize.xLarge)
                    }
                }
            }
        }
    }
}

struct UpNextSystemSmall_Previews: PreviewProvider {
    static var previews: some View {
        UpNextSystemSmallView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .preferredColorScheme(.light)
            .previewDisplayName("Small Light")

        UpNextSystemSmallView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .preferredColorScheme(.dark)
            .previewDisplayName("Small dark")

        UpNextSystemSmallView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .preferredColorScheme(.dark)
            .dynamicTypeSize(.xxxLarge)
            .previewDisplayName("Small dark xxxLarge font")

        UpNextSystemSmallView(entry: UpNextEntry.isTooFarAhead())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .preferredColorScheme(.light)
            .previewDisplayName("Too early light")

        UpNextSystemSmallView(entry: UpNextEntry.isTooFarAhead())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .preferredColorScheme(.dark)
            .previewDisplayName("Too early dark")

        UpNextSystemSmallView(entry: UpNextEntry.noMoreEvents())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .preferredColorScheme(.light)
            .previewDisplayName("No More Events Light")

        UpNextSystemSmallView(entry: UpNextEntry.noMoreEvents())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .preferredColorScheme(.dark)
            .previewDisplayName("No More Events dark")

        UpNextSystemSmallView(entry: UpNextEntry.noMoreEvents())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .preferredColorScheme(.dark)
            .dynamicTypeSize(.xxxLarge)
            .previewDisplayName("xxxLarge font")
    }
}
