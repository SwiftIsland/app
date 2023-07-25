//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

struct AllMentorsRequest: Request {
    typealias Output = Mentor

    var path = "mentors"
}
