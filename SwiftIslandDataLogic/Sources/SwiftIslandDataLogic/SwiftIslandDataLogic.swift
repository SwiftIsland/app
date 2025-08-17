import SwiftUI
import os.log

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

    func fetchTicket(slug: String, from checkinList: String) async throws -> Ticket

    func fetchAnswers(for tickets: [Ticket], in checkinList: String) async throws -> [Int: [Answer]]

    func fetchPuzzles() async -> [Puzzle]

    func fetchSponsors() async throws -> Sponsors
}

public enum DataLogicError: Error {
    case incorrectSlug
    case requestError(message: String)
    case unknowError
}

struct TitoAPIError: Error, Decodable {
    let message: String
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
    }

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: SwiftIslandDataLogic.self)
    )

    /// Fetches all the stored locations
    /// - Returns: Array of `Location`
    public func fetchLocations() async -> [Location] {
        [Location.forPreview()]
    }

    /// Fetches all the mentors from Firebase
    /// - Returns: Array of `Mentor`
    public func fetchMentors() async -> [Mentor] {
        Mentor.forWorkshop()
    }

    /// Fetches all the pages from Firebase and stores
    /// - Returns: Array of `Page`
    public func fetchPages() async -> [Page] {
        [Page.forPreview()]
    }

    /// Fetches all the activities available.
    ///
    /// Each activity is seperate from an event; an activity is unique, such as "VisionOS Workshop", but it can happen multiple times.
    /// - Returns: Array of `Activity`
    @discardableResult
    public func fetchActivities() async -> [Activity] {
        [Activity.forPreview()]
    }

    /// Fetches the db events from firebase and converts them to a `Event`
    /// - Returns: Array of `Event`
    public func fetchEvents() async -> [Event] {
        [Event.forPreview()]
    }

    /// Fetches the default setup of the packing items available on Firebase. Should only be fetched once per instance
    /// - Returns: Array of `PackingItem` from firebase
    public func fetchPackingListItemsFromFirebase() async -> [PackingItem] {
        [PackingItem.forPreview()]
    }

    public func fetchFAQItems() async -> [FAQItem] {
        [FAQItem.forPreview()]
    }

    public func fetchTicket(slug: String, from checkinList: String) async throws -> Ticket {
        guard let url = URL(string: "https://checkin.tito.io/checkin_lists/\(checkinList)/tickets/\(slug)") else {
            throw DataLogicError.incorrectSlug
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return try await fetchModel(Ticket.self, from: url, decoder: decoder)
    }

    public func fetchAnswers(for checkinList: String) async throws -> [Answer] {
        guard let url = URL(string: "https://checkin.tito.io/checkin_lists/\(checkinList)/answers") else {
            throw DataLogicError.incorrectSlug
        }
        return try await fetchModel(Array<Answer>.self, from: url)
    }

    public func fetchSponsors() async throws -> Sponsors {
        let url = URL(string: "https://swiftisland.nl/api/sponsors.json")!
        return try await fetchModel(Sponsors.self, from: url)
    }

    public func fetchAnswers(for tickets: [Ticket], in checkinList: String) async throws -> [Int: [Answer]] {
        let allAnswers = try await fetchAnswers(for: checkinList)
        var result: [Int: [Answer]] = [:]
        for ticket in tickets {
            result[ticket.id] = allAnswers.filter({ $0.ticketId == ticket.id })
        }
        return result
    }

    public func fetchPuzzles() async -> [Puzzle] {
        [Puzzle.forPreview()]
    }
}

private extension SwiftIslandDataLogic {
    func fetchModel<M: Decodable>(_ model: M.Type, from url: URL, decoder: JSONDecoder = JSONDecoder()) async throws -> M {
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            if let error = try? decoder.decode(TitoAPIError.self, from: data) {
                throw DataLogicError.requestError(message: error.message)
            } else if let error = String(data: data, encoding: .utf8) {
                throw DataLogicError.requestError(message: error)
            } else {
                throw DataLogicError.unknowError
            }
        }
        let model = try decoder.decode(M.self, from: data)
        return model
    }
}
