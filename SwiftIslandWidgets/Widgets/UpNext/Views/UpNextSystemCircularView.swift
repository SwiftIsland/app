//
// Created by Sidney de Koning for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//
import SwiftUI
import WidgetKit
import SwiftIslandDataLogic

struct UpNextSystemCircularView: View {
    var body: some View {
        ZStack {
//            AccessoryWidgetBackground()
            VStack {
                ViewThatFits {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fill)
                        .frame(width: 32, height: 32)
                        .shadow(color: .primary.opacity(0.2), radius: 5, x: 0, y: 0)
                }
            }
        }
    }
}

struct UpNextSystemCircularView_Previews: PreviewProvider {
    static var previews: some View {
        UpNextSystemCircularView()
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .preferredColorScheme(.light)
            .previewDisplayName("Circular light")

        UpNextSystemCircularView()
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .preferredColorScheme(.dark)
            .previewDisplayName("Circular dark")
    }
}
