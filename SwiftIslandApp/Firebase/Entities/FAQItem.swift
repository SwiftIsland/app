//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

struct FAQItem: Response {
    var id: String
    var question: String
    var answer: String
}

extension FAQItem: Hashable { }
extension FAQItem: Identifiable { }
