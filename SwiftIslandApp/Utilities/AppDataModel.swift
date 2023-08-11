//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation
import os.log
import SwiftUI
import Defaults
import SwiftIslandDataLogic

/// The state of the app, if the app is loading data, this state will be `initialising`.
enum AppState {
    case initialising
    case loaded
}

let checkinListSlug = "chk_pFTTuxa0daVl9rVYGI3l3qg"

/// AppDataModel hold app data that is used by multiple views and is shared as an environment variable to the views.
/// This class is used on the main dispatch queue
final class AppDataModel: ObservableObject {
    @Published var appState = AppState.initialising
    @Published var mentors: [Mentor] = []
    @Published var pages: [Page] = []
    @Published var activities: [Activity] = []
    @Published var events: [Event] = []
    @Published var locations: [Location] = []
    @Published var tickets: [Ticket] = []

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: AppDataModel.self)
    )

    private let dataLogic: DataLogic

    init(dataLogic: DataLogic = SwiftIslandDataLogic()) {
        self.dataLogic = dataLogic
        if !isShowingPreview() {
            Task {
                await fetchData()
            }
        }
    }

    /// Checks the event list and pick the next event from it
    /// - Returns: The next event, if there is any
    func nextEvent() async -> Event? {
        if events.count == 0 {
            self.events = await fetchEvents()
        }

        return events.sorted(by: { $0.startDate < $1.startDate }).first(where: { $0.startDate > Date() })
    }

    /// Fetches all the stored locations
    /// - Returns: Array of `Location`
    @MainActor
    func fetchLocations() async {
        self.locations = await dataLogic.fetchLocations()
    }

    /// Fetches items for packing list. If none are stored locally, it'll get the list from Firebase.
    /// - Returns: Array of `PackingItem`
    func fetchPackingListItems() async -> [PackingItem] {
        if Defaults[.packingItems].isEmpty {
            let firebaseItems = await dataLogic.fetchPackingListItemsFromFirebase()
            Defaults[.packingItems] = firebaseItems
            return firebaseItems
        }

        return Defaults[.packingItems]
    }
    
    func updateTickets() async -> [Ticket] {
        let storedTickets: [Ticket] = (try? KeychainManager.shared.get(key: .tickets) ?? []) ?? []
        var updatedTickets: [Ticket] = []
        // Todo make these request perform in parralel using an AsyncStream
        for ticket in storedTickets {
            // We never throw a way a ticket, if it can't be fetch, just use the stored version
            let updatedTicket = (try? await dataLogic.fetchTicket(slug: ticket.slug, from: checkinListSlug)) ?? ticket
            updatedTickets.append(updatedTicket)
        }
        return updatedTickets
    }
    
    func addTicket(slug: String) async throws -> Ticket {
        let ticket = try await dataLogic.fetchTicket(slug: slug, from: checkinListSlug)
        
        if let index = tickets.firstIndex(where: { $0.slug == ticket.slug }) {
            DispatchQueue.main.async {
                self.tickets[index] = ticket
            }
        } else {
            DispatchQueue.main.async {
                self.tickets.append(ticket)
            }
        }
        try KeychainManager.shared.store(key: .tickets, data: tickets)
        return ticket
    }
    
    func removeTicket(ticket: Ticket) throws {
        guard let index = tickets.firstIndex(where: { $0.id == ticket.id }) else { return }
        Task {
            let finished = await MainActor.run {
                self.tickets.remove(at: index)
                return true
            }
            if (finished) {
                try KeychainManager.shared.store(key: .tickets, data: tickets)
            }
        }
    }
}

private extension AppDataModel {
    @MainActor
    func fetchData() {
        Task {
            mentors = await fetchMentors().shuffled()
            pages = await fetchPages()
            activities = await fetchActivities()
            events = await fetchEvents()
            tickets = await updateTickets()
            appState = .loaded
        }
    }

    /// Fetches all the mentors from Firebase
    /// - Returns: Array of `Mentor`
    func fetchMentors() async -> [Mentor] {
        await dataLogic.fetchMentors()
    }

    /// Fetches all the pages from Firebase and stores
    /// - Returns: Array of `Page`
    func fetchPages() async -> [Page] {
        await dataLogic.fetchPages()
    }

    /// Fetches all the activities
    /// - Returns: Array of `Activity`
    func fetchActivities() async -> [Activity] {
        await dataLogic.fetchActivities()
    }

    func fetchEvents() async -> [Event] {
        await dataLogic.fetchEvents()
    }
}

