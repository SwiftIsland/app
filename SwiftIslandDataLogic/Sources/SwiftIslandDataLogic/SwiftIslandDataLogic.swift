import SwiftUI
import os.log
import Firebase
import FirebaseFirestore

/// This is the protocol definition for ``SwiftIslandDataLogic``, which can be used for dependency injection
public protocol DataLogic {
    init()

    /// Configures SwiftIslandDataLogic's dependencies. Required to be run at launch.
    static func configure()

    /// Fetches all the stored locations
    /// - Returns: Array of `Location`
    func fetchLocations() async -> [Location]

    /// Fetches all the mentors from Firebase
    /// - Returns: Array of `Mentor`
    func fetchMentors() async -> [Mentor]

    /// Fetches all the pages from Firebase and stores
    /// - Returns: Array of `Page`
    func fetchPages() async -> [Page]

    /// Fetches all the activities available.
    ///
    /// Each activity is seperate from an event; an activity is unique, such as "VisionOS Workshop", but it can happen multiple times.
    /// - Returns: Array of `Activity`
    @discardableResult
    func fetchActivities() async -> [Activity]

    /// Fetches the db events from firebase and converts them to a `Event`
    /// - Returns: Array of `Event`
    func fetchEvents() async -> [Event]

    /// Fetches the default setup of the packing items available on Firebase. Should only be fetched once per instance
    /// - Returns: Array of `PackingItem`
    func fetchPackingListItemsFromFirebase() async -> [PackingItem]

    /// Fetches the FAQ items
    /// - Returns: Array of `FAQItem`
    func fetchFAQItems() async -> [FAQItem]
}

/// SwiftIslandDataLogic is the data logic module for the Swift Island apps.
/// This package handles the communication between the app and the firebase backend. It also provides the entities needed for the client apps to function properly.
///
/// The client app is required to embed the `GoogleService-Info.plist` file into their project and make sure the Firebase project is setup properly. This package might offer support
/// for more things that the client app is able to use, depending on the rules setup in the firebase project.
///
/// When launching the app, make sure to call the `SwiftIslandDataLogic.configure()` method. This will configure a default Firebase app.
public class SwiftIslandDataLogic: DataLogic, ObservableObject {

    @Published var activities: [Activity] = []

    required public init() { }

    /// Configures SwiftIslandDataLogic's dependencies. Required to be run at launch.
    public static func configure() {
        FirebaseApp.configure()
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

    /// Fetches all the activities available.
    ///
    /// Each activity is seperate from an event; an activity is unique, such as "VisionOS Workshop", but it can happen multiple times.
    /// - Returns: Array of `Activity`
    @discardableResult
    public func fetchActivities() async -> [Activity] {
        let request = AllActivitiesRequest()

        let activities = await fetchFromFirebase(forRequest: request)
        self.activities = activities
        return activities
    }

    /// Fetches the db events from firebase and converts them to a `Event`
    /// - Returns: Array of `Event`
    public func fetchEvents() async -> [Event] {
        if activities.isEmpty {
            await fetchActivities()
        }

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
