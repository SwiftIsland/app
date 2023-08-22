//
//  File.swift
//  
//
//  Created by Niels van Hoorn on 2023-08-11.
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
    
    init() {
        self.id = 0
        self.slug = ""
        self.firstName = ""
        self.lastName = ""
        self.releaseTitle = ""
        self.reference = ""
        self.registrationReference = ""
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    public init(from data: Data) throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        self = try decoder.decode(Ticket.self, from: data)
    }
}

extension Ticket: Decodable, Encodable {
    enum CodingKeys : String, CodingKey {
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
    public static let empty: Ticket = Ticket()
    
    public var name: String {
        return "\(firstName) \(lastName)"
    }
    
    public var title: String {
        return releaseTitle
    }
    
    public var icon: String {
        switch(releaseTitle.lowercased()) {
        case "conference ticket": return "ticket.fill"
        case "hassle-free travel": return "bus.fill"
        case "super early bird": return "bird"
        case "child ticket": return "figure.and.child.holdinghands"
        case "mentor ticket","mentor ticket without hassle free travel": return "graduationcap"
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

public struct Answer {
    let id: Int
    let ticketId: Int
    public let questionId: Int
    let response: String
    public let humanizedResponse: String
}

extension Answer: Decodable {
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case ticketId = "ticket_id"
        case questionId = "question_id"
        case response = "response"
        case humanizedResponse = "humanized_response"
    }
}
