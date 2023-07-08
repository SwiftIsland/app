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
    case practical
//    case account

    var tabItem: TabItem {
        switch self {
        case .home:
            return TabItem(title: "Conference", imageName: "person.3")
        case .practical:
            return TabItem(title: "Practical", imageName: "wallet.pass")
//        case .account:
//            return TabItem(title: "Account", imageName: "person.crop.circle")
        }
    }
}

