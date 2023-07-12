//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import Firebase

@main
struct MainApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            TabBarView()
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
                    if let URL = activity.webpageURL,
                       URL.host == "swiftisland.nl",
                       let components = URLComponents(url: URL, resolvingAgainstBaseURL: true),
                       let nfc = components.queryItems?.first(where: {$0.name == "nfc"})?.value {
                        print("NFC: \(nfc)")
                    }
            }
        }
    }
}
