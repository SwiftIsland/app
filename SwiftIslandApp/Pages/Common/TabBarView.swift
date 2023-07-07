//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedItem: Tab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            switch selectedItem {
            case .home:
                ConferencePageView()
            }

        }
        .safeAreaInset(edge: .bottom) {
            TabBarBarView(selectedItem: $selectedItem)
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabBarView()
                .previewDisplayName("Light mode")
            TabBarView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}
