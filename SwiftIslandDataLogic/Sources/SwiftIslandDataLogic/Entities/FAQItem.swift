//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

public struct FAQItem: Response {
    public var id: String
    public var question: String
    public var answer: String
}

extension FAQItem {
    public static func forPreview(id: String = "1",
                                  question: String = "Lorum ipsum",
                                  answer: String = "Oh yes!") -> FAQItem {
        FAQItem(id: id, question: question, answer: answer)
    }
}

extension FAQItem: Hashable { }
extension FAQItem: Identifiable { }
