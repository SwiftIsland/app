//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import XCTest
import SwiftIslandDataLogic
@testable import Swift_Island

final class AddDataModelTests: XCTestCase {

    var dataLogicMock: DataLogicMock!
    var sut: AppDataModel!

    override func setUpWithError() throws {
        dataLogicMock = DataLogicMock()

        sut = AppDataModel(dataLogic: dataLogicMock)
    }

    override func tearDownWithError() throws {
        sut = nil
        dataLogicMock = nil
    }

    // MARK: - Next Event

    func testNextEvent_allFutureEvents_shouldReturnFirstEvent() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for the correct event.")
        let events = [
            Event.forPreview(id: "1", startDate: Date(timeIntervalSinceNow: 60)),
            Event.forPreview(id: "2", startDate: Date(timeIntervalSinceNow: 61)),
            Event.forPreview(id: "3", startDate: Date(timeIntervalSinceNow: 62)),
            Event.forPreview(id: "4", startDate: Date(timeIntervalSinceNow: 63)),
            Event.forPreview(id: "5", startDate: Date(timeIntervalSinceNow: 64))
        ]
        dataLogicMock.fetchEventsReturnValue = events

        Task {
            // When
            let result = await sut.nextEvent()

            // Then
            XCTAssertEqual(result?.id, "1")

            expectation.fulfill()
        }

        wait(for: [expectation])
    }

    func testNextEvent_someFutureEvents_shouldReturnThirdEvent() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for the correct event.")
        let events = [
            Event.forPreview(id: "1", startDate: Date(timeIntervalSinceNow: -60)),
            Event.forPreview(id: "2", startDate: Date(timeIntervalSinceNow: -59)),
            Event.forPreview(id: "3", startDate: Date(timeIntervalSinceNow: 60)),
            Event.forPreview(id: "4", startDate: Date(timeIntervalSinceNow: 61)),
            Event.forPreview(id: "5", startDate: Date(timeIntervalSinceNow: 62))
        ]
        dataLogicMock.fetchEventsReturnValue = events

        Task {
            // When
            let result = await sut.nextEvent()

            // Then
            XCTAssertEqual(result?.id, "3")

            expectation.fulfill()
        }

        wait(for: [expectation])
    }

    func testNextEvent_allEventsHavePassed_shouldReturnNil() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for the correct event.")
        let events = [
            Event.forPreview(id: "1", startDate: Date(timeIntervalSinceNow: -60)),
            Event.forPreview(id: "2", startDate: Date(timeIntervalSinceNow: -59)),
            Event.forPreview(id: "3", startDate: Date(timeIntervalSinceNow: -58)),
            Event.forPreview(id: "4", startDate: Date(timeIntervalSinceNow: -57)),
            Event.forPreview(id: "5", startDate: Date(timeIntervalSinceNow: -56))
        ]
        dataLogicMock.fetchEventsReturnValue = events

        Task {
            // When
            let result = await sut.nextEvent()

            // Then
            XCTAssertNil(result)

            expectation.fulfill()
        }

        wait(for: [expectation])
    }

    func testNextEvent_noEvents_shouldReturnNil() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for the correct event.")
        dataLogicMock.fetchEventsReturnValue = []

        Task {
            // When
            let result = await sut.nextEvent()

            // Then
            XCTAssertNil(result)

            expectation.fulfill()
        }

        wait(for: [expectation])
    }

    // MARK: - Locations

    func testFetchLocations_existingLocations_shouldReturnLocations() {
        let expectation = XCTestExpectation(description: "Wait for the correct fetching of locations.")
        dataLogicMock.fetchLocationsReturnValue = [
            Location.forPreview(id: "1"),
            Location.forPreview(id: "2")
        ]

        Task {
            await sut.fetchLocations()
            XCTAssertEqual(sut.locations.count, 2)

            expectation.fulfill()
        }

        wait(for: [expectation])
    }

    func testFetchLocations_existingLocations_shouldReturnNoLocations() {
        let expectation = XCTestExpectation(description: "Wait for the correct fetching of locations.")
        dataLogicMock.fetchLocationsReturnValue = []

        Task {
            await sut.fetchLocations()
            XCTAssertEqual(sut.locations.count, 0)

            expectation.fulfill()
        }

        wait(for: [expectation])
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


}
