import SwiftUI
import os.log
import FirebaseFirestore

public class SwiftIslandDataLogic: ObservableObject {

    @Published var activities: [Activity] = []

    public init() {
        
    }

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: SwiftIslandDataLogic.self)
    )

    /// Fetches all the stored locations
    /// - Returns: Array of `Location`
    public func fetchLocations() async -> [Location] {
        let request = AllLocationsRequest()
        return await fetchFromFirebase(forRequest: request)
    }

    /// Fetches all the mentors from Firebase
    /// - Returns: Array of `Mentor`
    public func fetchMentors() async -> [Mentor] {
        let request = AllMentorsRequest()
        return await fetchFromFirebase(forRequest: request).sorted(by: { $0.order < $1.order })
    }

    /// Fetches all the pages from Firebase and stores
    /// - Returns: Array of `Page`
    public func fetchPages() async -> [Page] {
        let request = AllPagesRequest()
        return await fetchFromFirebase(forRequest: request)
    }

    /// Fetches all the activities
    /// - Returns: Array of `Activity`
    public func fetchActivities() async -> [Activity] {
        let request = AllActivitiesRequest()
        return await fetchFromFirebase(forRequest: request)
    }

    /// Fetches the db events from firebase and converts them to a `Event`
    /// - Returns: Array of `Event`
    public func fetchEvents() async -> [Event] {
        let request = AllEventsRequest()
        let dbEvents = await fetchFromFirebase(forRequest: request)

        let events: [Event] = dbEvents.compactMap { dbEvent in
            guard let activity = activities.first(where: { $0.id == dbEvent.activityId }) else { return nil }
            return Event(dbEvent: dbEvent, activity: activity)
        }.sorted(by: { $0.startDate < $1.startDate })

        return events
    }

    /// Fetches the default setup of the packing items available on Firebase. Should only be fetched once per instance
    /// - Returns: Array of `PackingItem` from firebase
    public func fetchPackingListItemsFromFirebase() async -> [PackingItem] {
        let request = AllPackingListItems()
        return await fetchFromFirebase(forRequest: request)
    }

    public func fetchFAQItems() async -> [FAQItem] {
        let request = AllFAQRequest()
        return await fetchFromFirebase(forRequest: request)
    }
}

private extension SwiftIslandDataLogic {

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
