//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    @Namespace private var namespace
    @State private var selectedItem: Tab = .home
    @Binding var appActionTriggered: AppActions?

    @State private var isShowingMentor = false

    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                switch selectedItem {
                case .home:
                    ConferencePageView(namespace: namespace, isShowingMentor: $isShowingMentor)
                case .practical:
                    PracticalPageView()
                case .schedule:
                    NavigationStack {
                        ScheduleView()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                TabBarBarView(selectedItem: $selectedItem)
                    .opacity(isShowingMentor ? 0 : 1)
            }
        }.onAppear {
            handleAppAction()
        }.onChange(of: appActionTriggered) { newValue in
            handleAppAction()
        }
    }

    func handleAppAction() {
        if let appActionTriggered {
            switch appActionTriggered {
            case .atTheConference:
                selectedItem = .practical
            }

            self.appActionTriggered = nil
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabBarView(appActionTriggered: .constant(nil))
                .previewDisplayName("Light mode")
            TabBarView(appActionTriggered: .constant(nil))
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}
