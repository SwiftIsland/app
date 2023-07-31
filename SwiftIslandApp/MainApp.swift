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
}

private extension MainApp {

    func handleOpenURL(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true), components.host == "swiftisland.nl" else { return }

        let actions = components.queryItems?.compactMap { URLTask(rawValue: $0) }
        actions?.forEach { handleUrlTask($0) }
    }

    func handleUrlTask(_ urlTask: URLTask) {
        switch urlTask {
        case .action(let appAction):
            handleAppAction(appAction)
        case .ticket(let slur):
            handleTicketSlur(slur)
        }
    }

    func handleAppAction(_ appAction: AppActions) {
        appActionTriggered = appAction

        switch appAction {
        case .atTheConference:
            Defaults[.userIsActivated] = true
        }
    }

    func handleTicketSlur(_ slur: String) {
        

        debugPrint("Got SLUR: \(slur)")
    }
}

enum URLTask {
    case action(appAction: AppActions)
    case ticket(slur: String)

    init?(rawValue: URLQueryItem) {
        switch rawValue.name {
        case "action":
            guard let value = rawValue.value, let actionTriggered = AppActions(rawValue: value) else { return nil }
            self = .action(appAction: actionTriggered)
        case "ticket":
            guard let value = rawValue.value else { return nil }
            self = .ticket(slur: value)
        default:
            return nil
        }
    }
}

enum AppActions: String {
    case atTheConference = "attheconference"
}
