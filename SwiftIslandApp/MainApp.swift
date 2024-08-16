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

        if let items = components.queryItems {
            guard let task = URLTask(items: items) else { return }
            handleUrlTask(task)
        }
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
        case .seal(let slug, let key):
            if slug == "reset" {
                Defaults.reset(.puzzleStatus)
                Defaults.reset(.puzzleHints)
                currentPuzzleSlug = nil
            } else {
                findSlug(slug: slug, key: key)
            }
        }
    }
    
    func findSlug(slug: String, key: String) {
        if slug == "reset" {
            Defaults.reset(.puzzleStatus)
            Defaults.reset(.puzzleHints)
        } else {
            let currentStatus = Defaults[.puzzleStatus][slug]
            if currentStatus == nil || currentStatus == .notFound {
                Defaults[.puzzleStatus][slug] = .found
            }
            if let puzzle = appDataModel.puzzles.first(where: { $0.slug == slug }) {
                if let hint = try? decrypt(value: puzzle.encryptedHint, solution: key, type: Hint.self) {
                    Defaults[.puzzleHints][puzzle.slug] = hint
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
    case seal(slug: String, key: String)

    init?(items: [URLQueryItem]) {
        for item in items {
            if let task = URLTask.parseItem(item: item, allItems: items) {
                self = task
                return
            }
        }
        return nil
    }
    
    static func parseItem(item: URLQueryItem, allItems: [URLQueryItem]) -> URLTask? {
        switch item.name {
        case "action":
            guard let value = item.value, let actionTriggered = AppActions(rawValue: value) else { return nil }
            return .action(appAction: actionTriggered)
        case "ticket":
            guard let value = item.value else { return nil }
            return .ticket(slug: value)
        case "seal":
            guard let value = item.value, let key
                    = allItems.first(where: {$0.name == "key"})?.value else { return nil }
            
            return .seal(slug: value, key: key)
        default:
            return nil
        }
    }
}

enum AppActions: String {
    case atTheConference = "ihavearrived"
    case atHome = "athome"
}
