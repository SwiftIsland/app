//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

extension LinearGradient {
    static var defaultBackground: some View {
        LinearGradient(
            colors: [.conferenceBackgroundFrom, .conferenceBackgroundTo],
            startPoint: UnitPoint(x: 0, y: 0.1),
            endPoint: UnitPoint(x: 1, y: 1)
        )
        .ignoresSafeArea()
    }
}
