//
// Created by Sidney de Koning for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//
import SwiftUI
import WidgetKit
import SwiftIslandDataLogic

struct UpNextSystemRectangularView: View {
    var entry: UpNextProvider.Entry

    var body: some View {
        ZStack {
            if let event = entry.event {
                AccessoryWidgetBackground()
                    .cornerRadius(10)
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Circle()
                                .fill(event.activity.type.color)
                                .frame(width: 5)
                            Text(event.activity.type.rawValue)
                                .font(.body)
                                .foregroundColor(event.activity.type.color)
                                .fontWeight(.light)
                        }
                        Text(event.activity.title)
                            .font(.body)
                            .minimumScaleFactor(0.5)
                            .padding(.bottom, 2)

                        Spacer()
                        Text(event.startDate.relativeDateDisplay())
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .dynamicTypeSize(DynamicTypeSize.small ... DynamicTypeSize.xLarge)
            } else {
                if entry.isTooFarInTheFuture {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Up Next:")
                            .font(.caption)
                            .fontWeight(.light)
                        Spacer()
                        Text("You are to early")
                            .font(.caption)
                            .fontWeight(.light)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                } else {
                    VStack(alignment: .center) {
                        Image("Logo")
                            .resizable()
                            .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                            .frame(width: 36)
                            .shadow(color: .primary.opacity(0.2), radius: 5, x: 0, y: 0)
                            .padding(.top, 8)
                        Text("Until next year!")
                            .font(.caption2)
                            .fontWeight(.light)
                            .multilineTextAlignment(.leading)
                            .dynamicTypeSize(DynamicTypeSize.small ... DynamicTypeSize.xLarge)
                    }
                }
            }
        }
    }
}

struct UpNextSystemRectangularView_Previews: PreviewProvider {
    static var previews: some View {
        UpNextSystemRectangularView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .preferredColorScheme(.light)
            .previewDisplayName("Rectangular light")

        UpNextSystemRectangularView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .preferredColorScheme(.dark)
            .previewDisplayName("Rectangular dark")

        UpNextSystemRectangularView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .preferredColorScheme(.dark)
            .dynamicTypeSize(.xxxLarge)
            .previewDisplayName("Rectangular dark xxxLarge font")

        UpNextSystemRectangularView(entry: UpNextEntry.isTooFarAhead())
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .preferredColorScheme(.light)
            .previewDisplayName("Too early light")

        UpNextSystemRectangularView(entry: UpNextEntry.isTooFarAhead())
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .preferredColorScheme(.dark)
            .previewDisplayName("Too early dark")

        UpNextSystemRectangularView(entry: UpNextEntry.noMoreEvents())
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .preferredColorScheme(.light)
            .previewDisplayName("No more events light")

        UpNextSystemRectangularView(entry: UpNextEntry.noMoreEvents())
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .preferredColorScheme(.dark)
            .previewDisplayName("No more events dark")
    }
}
