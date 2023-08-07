//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

private struct OffsetPreferenceKey: PreferenceKey {
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { }

    static var defaultValue: CGFloat = .zero
}

struct ScrollViewOffset<Content: View>: View {
    let content: () -> Content
    let onOffsetChange: (CGFloat) -> Void

    init(@ViewBuilder content: @escaping () -> Content, onOffsetChange: @escaping (CGFloat) -> Void) {
        self.content = content
        self.onOffsetChange = onOffsetChange
    }

    var body: some View {
        ScrollView {
            offsetReader
            content()
                .padding(.top, -8)
        }
        .coordinateSpace(name: "frameLayer")
        .onPreferenceChange(OffsetPreferenceKey.self, perform: onOffsetChange)
    }

    var offsetReader: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: OffsetPreferenceKey.self,
                    value: proxy.frame(in: .named("frameLayer")).minY
                )
        }
        .frame(height: 0)
    }
}
