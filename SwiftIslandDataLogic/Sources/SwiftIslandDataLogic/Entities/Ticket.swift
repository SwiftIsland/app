//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

public struct Ticket {
    public let id: Int
    public let slug: String
    let firstName: String
    let lastName: String
    let releaseTitle: String
    let reference: String
    let registrationReference: String
    let createdAt: Date
    let updatedAt: Date

    internal init(id: Int, slug: String, firstName: String, lastName: String, releaseTitle: String, reference: String, registrationReference: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.slug = slug
        self.firstName = firstName
        self.lastName = lastName
        self.releaseTitle = releaseTitle
        self.reference = reference
        self.registrationReference = registrationReference
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    init() {
        self.init(id: 0, slug: "", firstName: "", lastName: "", releaseTitle: "", reference: "", registrationReference: "", createdAt: Date(), updatedAt: Date())
    }
}

extension Ticket: Decodable, Encodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case slug = "slug"
        case firstName = "first_name"
        case lastName = "last_name"
        case releaseTitle = "release_title"
        case reference = "reference"
        case registrationReference = "registration_reference"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

extension Ticket: Identifiable { }
extension Ticket: Equatable { }
extension Ticket: Hashable { }

extension Ticket {
    public static let empty = Ticket()

    public var name: String {
        return "\(firstName) \(lastName)"
    }

    public var title: String {
        return releaseTitle
    }

    public var icon: String {
        switch releaseTitle.lowercased() {
        case "conference ticket": return "ticket.fill"
        case "hassle-free travel": return "bus.fill"
        case "super early bird": return "bird"
        case "child ticket": return "figure.and.child.holdinghands"
        case "mentor ticket", "mentor ticket without hassle free travel": return "graduationcap"
        case "significant other ❤️": return "heart.circle.fill"
        default: return "ticket.fill"
        }
    }

    public var titoURL: URL? {
        URL(string: "https://ti.to/swiftisland/2023/tickets/\(slug)")
    }

    public var editURL: URL? {
        URL(string: "https://ti.to/swiftisland/2023/tickets/\(slug)/settings")
    }
}

// MARK: - SwiftUI Preview helper

extension Ticket {
    static public func forPreview(id: Int = 1,
                                  slug: String = "abc123",
                                  firstName: String = "John",
                                  lastName: String = "Appleseed",
                                  releaseTitle: String = "Conference Ticket",
                                  reference: String = "R2D2-1",
                                  registrationReference: String = "R2D2",
                                  createdAt: Date = Date(timeIntervalSinceNow: ((60 * 60) * 24) * 5), // 5 days ago
                                  updatedAt: Date = Date(timeIntervalSinceNow: ((60 * 60) * 24) * 1)) -> Ticket { // 1 day ago
        Ticket(id: id,
               slug: slug,
               firstName: firstName,
               lastName: lastName,
               releaseTitle: releaseTitle,
               reference: reference,
               registrationReference: registrationReference,
               createdAt: createdAt,
               updatedAt: updatedAt)
    }
}

// MARK: - Answer

public struct Answer {
    let id: Int
    let ticketId: Int
    public let questionId: Int
    let response: String
    public let humanizedResponse: String
}

extension Answer: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case ticketId = "ticket_id"
        case questionId = "question_id"
        case response = "response"
        case humanizedResponse = "humanized_response"
    }
}
