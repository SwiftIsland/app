//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//

import Foundation
import Defaults

struct Hint: Decodable, Encodable, Defaults.Serializable {
    let number: Int
    let text: String
    var used: Bool = false
    var description: String {
        return "\(number). \(text)"
    }
    mutating func toggleUsed() {
        used = !used
    }
}
