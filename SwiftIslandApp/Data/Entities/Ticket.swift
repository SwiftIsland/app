//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

struct Ticket: Codable {
    let id: String
    let addDate: Date
    let name: String
}

extension Ticket: Identifiable { }
