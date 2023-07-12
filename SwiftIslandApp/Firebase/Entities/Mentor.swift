//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

enum UserInfoType: String, Codable {
    case participant
    case mentor
    case staff
    case admin
}

struct Mentor: Response {
    let userId: String
    let firstName: String
    let lastName: String
    let userType: UserInfoType
    let headerImageUrl: URL?
    let highResImageUrl: URL?
    let description: String?
}

extension Mentor: Identifiable {
    var id: String { userId }
}

extension Mentor: Hashable { }

extension Mentor {
    static func forPreview(userId: String = "1",
                           firstName: String = "John",
                           lastName: String = "Appleseed",
                           userType: UserInfoType = .mentor,
                           headerImageUrl: URL? = nil,
                           highResImageUrl: URL? = nil,
                           description: String? = nil) -> Mentor {
        Mentor(userId: userId,
               firstName: firstName,
               lastName: lastName,
               userType: userType,
               headerImageUrl: headerImageUrl,
               highResImageUrl: highResImageUrl,
               description: description)
    }
}
