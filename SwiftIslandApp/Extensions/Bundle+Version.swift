//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

extension Bundle {
    var appBuild: String { getInfo("CFBundleVersion") }
    var appVersionLong: String { getInfo("CFBundleShortVersionString") }

    func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
}
