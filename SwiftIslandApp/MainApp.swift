//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import Firebase
import Defaults
import SwiftIslandDataLogic

@main
struct MainApp: App {
    init() {
        SwiftIslandDataLogic.configure()
    }

    @StateObject private var appDataModel = AppDataModel()
    @State private var appActionTriggered: AppActions? = nil
    @State private var ticketToShow: Ticket?

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
                        .shadow(radius: 20)
                }
            }
            .onOpenURL { url in
                handleOpenURL(url)
            }
            .sheet(item: $ticketToShow, onDismiss: {
                debugPrint("Dismissed!")
            }, content: { ticket in
                if let url = ticket.titoURL {
                    SafariWebView(url: url)
                } else {
                    Text("The ticket ID provided was invalid")
                }
            })
//            .onAppear {
//                self.storedTickets = (try? KeychainManager.shared.get(key: .tickets) ?? []) ?? []
//            }
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
        case .ticket(let slug):
            Task {
                do {
                    try await handleTicketSlug(slug)
                }
                catch {
                    print(error)
                }
            }
        }
    }

    func handleAppAction(_ appAction: AppActions) {
        appActionTriggered = appAction

        switch appAction {
        case .atTheConference:
            Defaults[.userIsActivated] = true
        }
    }

    /// This method handles the storing of the ticket to the keychain and presenting the result
    /// - Parameter slur: The slur to store
    func handleTicketSlug(_ slug: String) async throws {
        do {
            self.ticketToShow = try await appDataModel.addTicket(slug: slug)
        } catch {
            // TODO: Show error view for requesting and adding to the keychain
            debugPrint("Error adding ticket! Error: \(error)")
        }
    }
}

enum URLTask {
    case action(appAction: AppActions)
    case ticket(slug: String)

    init?(rawValue: URLQueryItem) {
        switch rawValue.name {
        case "action":
            guard let value = rawValue.value, let actionTriggered = AppActions(rawValue: value) else { return nil }
            self = .action(appAction: actionTriggered)
        case "ticket":
            guard let value = rawValue.value else { return nil }
            self = .ticket(slug: value)
        default:
            return nil
        }
    }
}

enum AppActions: String {
    case atTheConference = "attheconference"
}
