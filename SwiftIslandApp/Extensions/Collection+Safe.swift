//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index?) -> Iterator.Element? {
        guard let index = index else { return nil }
        return indices.contains(index) ? self[index] : nil
    }
}

extension Dictionary where Key: Hashable {
    subscript (safe key: Key) -> Iterator.Element? {
        guard let index = self.index(forKey: key) else { return nil }
        return self[safe: index]
    }
}
