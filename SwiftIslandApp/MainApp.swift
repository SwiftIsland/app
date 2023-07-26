//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import Firebase
import Defaults

@main
struct MainApp: App {
    init() {
        FirebaseApp.configure()
    }

    @StateObject private var appDataModel = AppDataModel()
    @State private var appActionTriggered: AppActions? = nil

    var body: some Scene {
        WindowGroup {
            ZStack {
                if case .loaded = appDataModel.appState {
                    TabBarView(appActionTriggered: $appActionTriggered)
                        .environmentObject(appDataModel)
                } else {
                    SwiftIslandLogo(isAnimating: true)
                        .frame(maxWidth: 250)
                        .padding(20)
                }
            }
            .onOpenURL { url in
                handleOpenURL(url)
            }
        }
    }

    func handleOpenURL(_ url: URL) {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                components.host == "swiftisland.nl"
        else { return }
        guard
            let actionQI = components.queryItems?.first(where: { $0.name.lowercased() == "action" })?.value?.lowercased(),
            let action = AppActions(rawValue: actionQI)
        else { return }

        appActionTriggered = action

        switch action {
        case .atTheConference:
            Defaults[.userIsActivated] = true
        }
    }
}

enum AppActions: String {
    case atTheConference = "attheconference"
}
