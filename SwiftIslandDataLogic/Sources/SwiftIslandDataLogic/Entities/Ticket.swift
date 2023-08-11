//
//  File.swift
//  
//
//  Created by Niels van Hoorn on 2023-08-11.
//

import Foundation

public struct Ticket {
    let id: Int
    let slug: String
    let firstName: String
    let lastName: String
    let releaseTitle: String
    let reference: String
    let registrationReference: String
    let createdAt: Date
    let updatedAt: Date
    
    init(from data: Data) throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        self = try decoder.decode(Ticket.self, from: data)
    }
}

extension Ticket:Decodable {
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

//extension Ticket {
//    func accomodation(checkinList: String) async throws -> String? {
//        let answers = try await getAnswers(for: checkinList)
//        return answers.first(where: { $0.ticketId == self.id })?.humanizedResponse
//    }
//}

public struct Answer {
    let id: Int
    let ticketId: Int
    let questionId: Int
    let response: String
    let humanizedResponse: String
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
