//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    @Namespace private var namespace
    @State private var selectedItem: Tab = .home

    @State private var isShowingMentor = false
    @State private var selectedMentor: Mentor?

    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                switch selectedItem {
                case .home:
                    ConferencePageView(namespace: namespace, selectedMentor: $selectedMentor, isShowingMentor: $isShowingMentor)
                case .practical:
                    PracticalPageView()
                }

            }
            .safeAreaInset(edge: .bottom) {
                TabBarBarView(selectedItem: $selectedItem)
            }

            if let mentor = selectedMentor, isShowingMentor {
                let bindingMentor = Binding { mentor } set: { selectedMentor = $0 }
                ConferenceMentorView(namespace: namespace, mentor: bindingMentor, isShowingMentor: $isShowingMentor)
            }
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
