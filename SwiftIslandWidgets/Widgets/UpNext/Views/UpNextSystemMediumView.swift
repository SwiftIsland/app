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
                VStack(alignment: .center) {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                        .frame(width: 36)
                        .shadow(color: .primary.opacity(0.2), radius: 5, x: 0, y: 0)
                    Text("There are no more events to show here!\n\nWe hope to see you again in 2024!")
                        .font(.footnote)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .padding()
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
