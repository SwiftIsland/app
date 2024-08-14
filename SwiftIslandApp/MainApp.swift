//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import Defaults
import SwiftIslandDataLogic

@main
struct MainApp: App {
    init() {
        SwiftIslandDataLogic.configure()
    }

    @StateObject private var appDataModel = AppDataModel()
    @State private var appActionTriggered: AppActions?
    @State private var showTicketAlert = false
    @State private var showTicketMessage: String = ""
    @State private var currentPuzzleSlug: String?

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
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
                if let url = activity.webpageURL {
                    handleOpenURL(url)
                }
            }

            .sheet(
                isPresented: .constant(currentPuzzleSlug != nil),
                onDismiss: {
                    currentPuzzleSlug = nil
                },
                content: {
                    NavigationStack {
                        PuzzlePageView(currentPuzzleSlug: $currentPuzzleSlug.wrappedValue)
                    }
                    .tint(.questionMarkColor)
                    .environmentObject(appDataModel)
                }
            )
            // TODO: Make this a navigation path to the actual ticket
            .alert("Ticket Added", isPresented: $showTicketAlert, actions: {
                Button("OK") {
                    showTicketAlert = false
                    showTicketMessage = ""
                }
            }, message: {
                Text("\(showTicketMessage)\n\nYou can find your ticket under Practical → Before you leave → Tickets")
            })
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
                } catch {
                    print(error)
                }
            }
        case .seal(let slug):
            if slug == "reset" {
                Defaults.reset(.puzzleStatus)
                Defaults.reset(.puzzleHints)
            } else {
                let currentStatus = Defaults[.puzzleStatus][slug]
                if currentStatus == nil || currentStatus == .notFound {
                    Defaults[.puzzleStatus][slug] = .found
                }
            }
            currentPuzzleSlug = slug
        }
    }

    func handleAppAction(_ appAction: AppActions) {
        appActionTriggered = appAction

        switch appAction {
        case .atTheConference:
            Defaults[.userIsActivated] = true
        case .atHome:
            Defaults[.userIsActivated] = false
        }
    }

    /// This method handles the storing of the ticket to the keychain and presenting the result
    /// - Parameter slug: The slug to store
    func handleTicketSlug(_ slug: String) async throws {
        do {
            if let ticket = try await appDataModel.updateTicket(slug: slug) {
                showTicketAlert = true
                showTicketMessage = "\(ticket.title) ticket for \(ticket.name) was added successfully."
            }
        } catch {
            // TODO: Show error view for requesting and adding to the keychain
            debugPrint("Error adding ticket! Error: \(error)")
        }
    }
}

enum URLTask {
    case action(appAction: AppActions)
    case ticket(slug: String)
    case seal(slug: String)

    init?(rawValue: URLQueryItem) {
        switch rawValue.name {
        case "action":
            guard let value = rawValue.value, let actionTriggered = AppActions(rawValue: value) else { return nil }
            self = .action(appAction: actionTriggered)
        case "ticket":
            guard let value = rawValue.value else { return nil }
            self = .ticket(slug: value)
        case "seal":
            guard let value = rawValue.value else { return nil }
            self = .seal(slug: value)
        default:
            return nil
        }
    }
}

enum AppActions: String {
    case atTheConference = "ihavearrived"
    case atHome = "athome"
}
