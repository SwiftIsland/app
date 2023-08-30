//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

extension View {
    func percentageOffset(x: Double = 0, y: Double = 0) -> some View {
        self.modifier(PercentageOffset(x: x, y: y))
    }
}


struct PercentageOffset: ViewModifier {
    let x: Double
    let y: Double

    @State private var size: CGSize = .zero

    func body(content: Content) -> some View {
        content
            .background( GeometryReader { geo in Color.clear.onAppear { size = geo.size } })
            .offset(x: size.width * x, y: size.height * y)
    }
}
