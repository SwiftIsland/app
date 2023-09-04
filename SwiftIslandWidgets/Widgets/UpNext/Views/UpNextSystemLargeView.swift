//
// Created by Sidney de Koning for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//
import SwiftUI
import WidgetKit
import SwiftIslandDataLogic

struct UpNextSystemLargeView: View {
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
                        HStack {
                            Image("SofíaSwidarowicz")
                                .resizable()
                                .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                                .frame(width: 64)
                                .shadow(color: .primary.opacity(0.2), radius: 5, x: 0, y: 0)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.orange, lineWidth: 1))
                                .scaledToFit()
                                .padding()
                            Spacer()
                            Text(event.activity.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineLimit(6)
                                .padding(.bottom, 8)
                        }

                        Spacer()
                        HStack {
                            Text(event.startDate.formatted())
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(event.startDate.relativeDateDisplay())
                                .font(.subheadline)
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
                            .shadow(color: .primary.opacity(0.2), radius: 5, x: 0, y: 0)
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

struct UpNextSystemLargeView_Previews: PreviewProvider {
    static var previews: some View {
        UpNextSystemLargeView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .preferredColorScheme(.light)
            .previewDisplayName("Large light")

        UpNextSystemLargeView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .preferredColorScheme(.dark)
            .previewDisplayName("Large dark")

        UpNextSystemLargeView(entry: UpNextEntry.forPreview())
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .preferredColorScheme(.dark)
            .dynamicTypeSize(.xxxLarge)
            .previewDisplayName("Large dark xxxLarge font")

        UpNextSystemLargeView(entry: UpNextEntry.isTooFarAhead())
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .preferredColorScheme(.light)
            .previewDisplayName("Too early light")

        UpNextSystemLargeView(entry: UpNextEntry.isTooFarAhead())
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .preferredColorScheme(.dark)
            .previewDisplayName("Too early dark")

        UpNextSystemLargeView(entry: UpNextEntry.noMoreEvents())
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .preferredColorScheme(.light)
            .previewDisplayName("No more events light")

        UpNextSystemLargeView(entry: UpNextEntry.noMoreEvents())
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .preferredColorScheme(.dark)
            .previewDisplayName("No more events dark")
    }
}
