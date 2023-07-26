//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation
import FirebaseFirestore
import os.log
import SwiftUI

/// The state of the app, if the app is loading data, this state will be `initialising`.
enum AppState {
    case initialising
    case loaded
}

/// AppDataModel hold app data that is used by multiple views and is shared as an environment variable to the views.
/// This class is used on the main dispatch queue
@MainActor
final class AppDataModel: ObservableObject {
    @Published var appState = AppState.initialising
    @Published var mentors: [Mentor] = []
    @Published var pages: [Page] = []
    @Published var activities: [Activity] = []
    @Published var events: [Event] = []

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: AppDataModel.self)
    )

    init() {
        if !isShowingPreview() {
            fetchData()
        }
    }

    func nextEvent() -> Event? {
        events.sorted(by: { $0.startDate < $1.startDate }).first
    }

    /// Fetches all the stored locations
    /// - Returns: Array of `Location`
    func fetchLocations() async -> [Location] {
        let request = AllLocationsRequest()
        return await fetchFromFirebase(forRequest: request)
    }
}

private extension AppDataModel {
    func fetchData() {
        Task {
            mentors = await fetchMentors()
            pages = await fetchPages()
            activities = await fetchActivities()
            events = await fetchEvents()

            appState = .loaded
        }
    }

    /// Fetches all the mentors from Firebase
    /// - Returns: Array of `Mentor`
    func fetchMentors() async -> [Mentor] {
        let request = AllMentorsRequest()
        return await fetchFromFirebase(forRequest: request).sorted(by: { $0.order < $1.order })
    }

    /// Fetches all the pages from Firebase and stores
    /// - Returns: Array of `Page`
    func fetchPages() async -> [Page] {
        let request = AllPagesRequest()
        return await fetchFromFirebase(forRequest: request)
    }

    /// Fetches all the activities
    /// - Returns: Array of `Activity`
    func fetchActivities() async -> [Activity] {
        let request = AllActivitiesRequest()
        return await fetchFromFirebase(forRequest: request)
    }

    func fetchEvents() async -> [Event] {
        let request = AllEventsRequest()
        let dbEvents = await fetchFromFirebase(forRequest: request)

        let events: [Event] = dbEvents.compactMap { dbEvent in
            guard let activity = activities.first(where: { $0.id == dbEvent.activityId }) else { return nil }
            return Event(dbEvent: dbEvent, activity: activity)
        }.sorted(by: { $0.startDate < $1.startDate })

        return events
    }

    /// Performs the fetch on Firebase with a logger if an issue arrises
    /// - Parameter request: The request to preform
    /// - Returns: The output
    func fetchFromFirebase<R: Request>(forRequest request: R) async -> [R.Output] {
        do {
            return try await Firestore.get(request: request)
        } catch {
            logger.error("Error getting documents for request with path \(request.path): \(error, privacy: .public)")
            return []
        }
    }
}
