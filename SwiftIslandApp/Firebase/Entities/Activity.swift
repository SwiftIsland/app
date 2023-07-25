//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

struct Activity: Response {
    let id: String
    let title: String
    let description: String
    let mentors: [String]
    let type: String
    let imageName: String?
    let duration: Double
}

extension Activity: Identifiable { }

extension Activity: Hashable { }
