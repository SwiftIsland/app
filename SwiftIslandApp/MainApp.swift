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
    @State private var ticketToShow: Ticket?
    @State private var storedTickets: [Ticket] = []

    var body: some Scene {
        WindowGroup {
            ZStack {
                if case .loaded = appDataModel.appState {
                    TabBarView(appActionTriggered: $appActionTriggered, storedTickets: $storedTickets)
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
            .sheet(item: $ticketToShow, onDismiss: {
                debugPrint("Dismissed!")
            }, content: { ticket in
                if let url = URL(string: "https://ti.to/swiftisland/2023/tickets/\(ticket.id)") {
                    SafariWebView(url: url)
                } else {
                    Text("The ticket ID provided was invalid")
                }
            })
            .onAppear {
                self.storedTickets = (try? KeychainManager.shared.get(key: .tickets) ?? []) ?? []
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

    /// This method handles the storing of the ticket to the keychain and presenting the result
    /// - Parameter slur: The slur to store
    func handleTicketSlur(_ slur: String) {
        do {
            var storedTickets: [Ticket] = (try? KeychainManager.shared.get(key: .tickets) ?? []) ?? []

            if let ticket = storedTickets.first(where: { $0.id == slur }) {
                self.ticketToShow = ticket
            } else {
                let ticket = Ticket(id: slur, addDate: Date(), name: "Ticket \(max(storedTickets.count + 1, 2))")
                storedTickets.append(ticket)

                try KeychainManager.shared.store(key: .tickets, data: storedTickets)
                self.ticketToShow = ticket
                self.storedTickets.append(ticket)
            }
        } catch {
            // TODO: Show error view for keychain issue, which should never happen
            debugPrint("Error handling keychain items! Error: \(error)")
        }
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
