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
                VStack(alignment: .center) {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                        .frame(width: 36)
                        .shadow(color: .primary.opacity(0.2), radius: 5, x: 0, y: 0)
                        .padding(.top, 8)
                    Text("There are no more events to show here!\n\nSee you again in 2024!")
                        .font(.footnote)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .padding()
                        .dynamicTypeSize(DynamicTypeSize.small ... DynamicTypeSize.xLarge)
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
