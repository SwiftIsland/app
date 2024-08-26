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
            return .orangeDark
        case .socialActivity:
            return .yellowDarker
        case .meal:
            return .green
        case .mandatoryEventActivity:
            return .purple
        case .transport:
            return .redLight
        case .inviteOnly:
            return .blue
        }
    }
}
