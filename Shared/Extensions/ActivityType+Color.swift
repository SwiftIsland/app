//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

extension ActivityType {
    var color: Color {
        switch self {
        case .workshop:
            return .purple
        case .socialActivity:
            return .yellowDark
        case .meal:
            return .green
        case .mandatoryEventActivity:
            return .redDark
        case .transport:
            return .orangeDark
        case .inviteOnly:
            return .purple
        }
    }
}
