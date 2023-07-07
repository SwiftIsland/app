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
    let headerImageUrl: String?
}

extension Mentor: Identifiable {
    var id: String { userId }
}
