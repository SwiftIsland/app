//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

struct TabItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let imageName: String
    var selected = false
}

enum Tab: CaseIterable {
    case home
//    case workshops
//    case account

    var tabItem: TabItem {
        switch self {
        case .home:
            return TabItem(title: "Conference", imageName: "person.3")
//        case .workshops:
//            return TabItem(title: "Workshops", imageName: "pencil.and.ruler")
//        case .account:
//            return TabItem(title: "Account", imageName: "person.crop.circle")
        }
    }
}

