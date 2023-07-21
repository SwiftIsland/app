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

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: AppDataModel.self)
    )

    init() {
        if !isShowingPreview() {
            fetchData()
        }
    }
}

private extension AppDataModel {
    func fetchData() {
        Task {
            mentors = await fetchMentors()
            pages = await fetchPages()

            appState = .loaded
        }
    }

    /// Fetches all the mentors from Firebase
    /// - Returns: Array of `Mentor`
    func fetchMentors() async -> [Mentor] {
        let request = FetchMentorsRequest()

        do {
            return try await Firestore.get(request: request).sorted(by: { $0.order < $1.order })
        } catch {
            logger.error("Error getting mentor documents: \(error, privacy: .public)")
            return []
        }
    }

    /// Fetches all the pages from Firebase and stores
    /// - Returns: Array `Page`
    func fetchPages() async -> [Page] {
        let request = PagesRequest()
        do {
            let pages = try await Firestore.get(request: request)

            print("GOT PAGES!")
            print(pages)

            return pages
        } catch {
            logger.error("Error getting page documents: \(error, privacy: .public)")
            return []
        }
    }
}
