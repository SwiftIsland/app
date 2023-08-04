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

/// AppDataModel hold app data that is used by multiple views and is shared as an environment variable to the views.
/// This class is used on the main dispatch queue
final class AppDataModel: ObservableObject {
    @Published var appState = AppState.initialising
    @Published var mentors: [Mentor] = []
    @Published var pages: [Page] = []
    @Published var activities: [Activity] = []
    @Published var events: [Event] = []
    @Published var locations: [Location] = []

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

    @MainActor
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
    @MainActor
    func fetchPackingListItems() async -> [PackingItem] {
        if Defaults[.packingItems].isEmpty {
            debugPrint("Fetching from firebase...")
            let firebaseItems = await dataLogic.fetchPackingListItemsFromFirebase()

            debugPrint("Got items: \(firebaseItems)")
            Defaults[.packingItems] = firebaseItems
            return firebaseItems
        }

        return Defaults[.packingItems]
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

            appState = .loaded
        }
    }

    /// Fetches all the mentors from Firebase
    /// - Returns: Array of `Mentor`
    @MainActor
    func fetchMentors() async -> [Mentor] {
        await dataLogic.fetchMentors()
    }

    /// Fetches all the pages from Firebase and stores
    /// - Returns: Array of `Page`
    @MainActor
    func fetchPages() async -> [Page] {
        await dataLogic.fetchPages()
    }

    /// Fetches all the activities
    /// - Returns: Array of `Activity`
    @MainActor
    func fetchActivities() async -> [Activity] {
        return await dataLogic.fetchActivities()
    }

    @MainActor
    func fetchEvents() async -> [Event] {
        return await dataLogic.fetchEvents()
    }
}
