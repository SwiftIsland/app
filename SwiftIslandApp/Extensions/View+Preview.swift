//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

extension View {
    /// `true` if this is called using the previews otherwise `false`. Can be used when fetching data
    var isPreview: Bool {
        isShowingPreview()
    }
}

func isShowingPreview() -> Bool {
#if DEBUG
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
#else
    return false
#endif
}
