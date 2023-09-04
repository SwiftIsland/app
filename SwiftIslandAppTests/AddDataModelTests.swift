//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import XCTest
import SwiftIslandDataLogic
@testable import Swift_Island

let ticketJSON = """
        {"id":9973691,"slug":"ti_testslug","first_name":"Sidney","last_name":"de Koning","release_title":"Organizer Ticket","reference":"RD2J-1","registration_reference":"RD2J","tags":null,"created_at":"2023-07-07T07:28:34.000Z","updated_at":"2023-07-07T07:32:17.000Z"}
        """

final class AddDataModelTests: XCTestCase {
    var dataLogicMock: DataLogicMock!

    override func setUpWithError() throws {
        dataLogicMock = DataLogicMock()
    }

    override func tearDownWithError() throws {
        dataLogicMock = nil
    }

    // MARK: - Next Event
    @MainActor
    func testNextEvent_allFutureEvents_shouldReturnFirstEvent() async {
        // Given
        let events = [
            Event.forPreview(id: "1", startDate: Date(timeIntervalSinceNow: 60)),
            Event.forPreview(id: "2", startDate: Date(timeIntervalSinceNow: 61)),
            Event.forPreview(id: "3", startDate: Date(timeIntervalSinceNow: 62)),
            Event.forPreview(id: "4", startDate: Date(timeIntervalSinceNow: 63)),
            Event.forPreview(id: "5", startDate: Date(timeIntervalSinceNow: 64))
        ]
        dataLogicMock.fetchEventsReturnValue = events

        // When
        let sut = AppDataModel(dataLogic: dataLogicMock)
        let result = await sut.nextEvent()

        // Then
        XCTAssertEqual(result?.id, "1")
    }

    func testNextEvent_someFutureEvents_shouldReturnThirdEvent() async {
        // Given
        let events = [
            Event.forPreview(id: "1", startDate: Date(timeIntervalSinceNow: -60)),
            Event.forPreview(id: "2", startDate: Date(timeIntervalSinceNow: -59)),
            Event.forPreview(id: "3", startDate: Date(timeIntervalSinceNow: 60)),
            Event.forPreview(id: "4", startDate: Date(timeIntervalSinceNow: 61)),
            Event.forPreview(id: "5", startDate: Date(timeIntervalSinceNow: 62))
        ]
        dataLogicMock.fetchEventsReturnValue = events

        // When
        let sut = AppDataModel(dataLogic: dataLogicMock)
        let result = await sut.nextEvent()

        // Then
        XCTAssertEqual(result?.id, "3")
    }

    func testNextEvent_allEventsHavePassed_shouldReturnNil() async {
        // Given
        let events = [
            Event.forPreview(id: "1", startDate: Date(timeIntervalSinceNow: -60)),
            Event.forPreview(id: "2", startDate: Date(timeIntervalSinceNow: -59)),
            Event.forPreview(id: "3", startDate: Date(timeIntervalSinceNow: -58)),
            Event.forPreview(id: "4", startDate: Date(timeIntervalSinceNow: -57)),
            Event.forPreview(id: "5", startDate: Date(timeIntervalSinceNow: -56))
        ]
        dataLogicMock.fetchEventsReturnValue = events

        // When
        let sut = AppDataModel(dataLogic: dataLogicMock)
        let result = await sut.nextEvent()

        // Then
        XCTAssertNil(result)
    }

    func testNextEvent_noEvents_shouldReturnNil() async {
        // Given
        dataLogicMock.fetchEventsReturnValue = []

        // When
        let sut = AppDataModel(dataLogic: dataLogicMock)
        let result = await sut.nextEvent()

        // Then
        XCTAssertNil(result)
    }

    // MARK: - Locations

    func testFetchLocations_existingLocations_shouldReturnLocations() async {
        // Given
        dataLogicMock.fetchLocationsReturnValue = [
            Location.forPreview(id: "1"),
            Location.forPreview(id: "2")
        ]

        // When
        let sut = AppDataModel(dataLogic: dataLogicMock)
        await sut.fetchLocations()

        // Then
        let locations = sut.locations
        XCTAssertEqual(locations.count, 2)
    }

    func testFetchLocations_existingLocations_shouldReturnNoLocations() async {
        // Given
        dataLogicMock.fetchLocationsReturnValue = []

        // When
        let sut = AppDataModel(dataLogic: dataLogicMock)
        await sut.fetchLocations()

        // Then
        let locations = sut.locations
        XCTAssertEqual(locations.count, 0)
    }
}

internal class DataLogicMock: DataLogic {
    static var configureInvokeCount = 0

    var fetchLocationsReturnValue: [Location] = []

    var fetchMentorsReturnValue: [Mentor] = []

    var fetchPagesReturnValue: [Page] = []

    var fetchActivitiesReturnValue: [Activity] = []

    var fetchEventsReturnValue: [Event] = []

    var fetchPackingListItemsFromFirebaseReturnValue: [PackingItem] = []

    var fetchFAQItemsReturnValue: [FAQItem] = []

    var fetchTicketReturnValue = Ticket.forPreview()

    var fetchAnswersReturnValue: [Int: [Answer]] = [:]

    var fetchPuzzlesReturnValue: [Puzzle] = []

    var fetchSponsorsReturnValue = Sponsors.forPreview()

    required init() { }

    static func configure() {
        configureInvokeCount += 1
    }

    func fetchLocations() async -> [Location] {
        return fetchLocationsReturnValue
    }

    func fetchMentors() async -> [Mentor] {
        return fetchMentorsReturnValue
    }

    func fetchPages() async -> [Page] {
        return fetchPagesReturnValue
    }

    func fetchActivities() async -> [Activity] {
        return fetchActivitiesReturnValue
    }

    func fetchEvents() async -> [Event] {
        return fetchEventsReturnValue
    }

    func fetchPackingListItemsFromFirebase() async -> [PackingItem] {
        return fetchPackingListItemsFromFirebaseReturnValue
    }

    func fetchFAQItems() async -> [FAQItem] {
        return fetchFAQItemsReturnValue
    }

    func fetchTicket(slug: String, from checkinList: String) async throws -> Ticket {
        return fetchTicketReturnValue
    }

    func fetchAnswers(for tickets: [Ticket], in checkinList: String) async throws -> [Int: [Answer]] {
        return fetchAnswersReturnValue
    }

    func fetchPuzzles() async -> [Puzzle] {
        return fetchPuzzlesReturnValue
    }

    func fetchSponsors() async throws -> Sponsors {
        return fetchSponsorsReturnValue
    }
}
