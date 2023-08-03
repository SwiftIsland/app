//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

extension Date {
    func relativeDateDisplay() -> String {
        RelativeDateTimeFormatter().localizedString(for: self, relativeTo: Date())
    }
}
