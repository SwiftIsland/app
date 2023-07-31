//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation
import Defaults

struct TabItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let imageName: String
    var selected = false
}

enum Tab: CaseIterable {
    case home
    case practical
    case schedule

    static var availableItems: [Tab] {
        if Defaults[.userIsActivated] {
            return [.home, .practical, .schedule]
        } else {
            return [.home, .practical]
        }
    }

    var tabItem: TabItem {
        switch self {
        case .home:
            return TabItem(title: "Conference", imageName: "person.3")
        case .practical:
            return TabItem(title: "Practical", imageName: "wallet.pass")
        case .schedule:
            return TabItem(title: "Schedule", imageName: "calendar.day.timeline.left")
        }
    }
}

