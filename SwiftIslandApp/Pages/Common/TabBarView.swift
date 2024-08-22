//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import Defaults
import SwiftIslandDataLogic

private enum Tab: CaseIterable {
    case home
    case practical
    case schedule
}

struct TabBarView: View {
    @Namespace private var namespace
    @State private var selectedItem: Tab = .home
    @State private var practicalNavigationPath = NavigationPath()
    @Binding var urlTaskTriggered: URLTask?

    @State private var isShowingMentor = false
    @EnvironmentObject private var appDataModel: AppDataModel

    @Default(.userIsActivated)
    private var userIsActivated

    var body: some View {
        let tabs: [Tab] = {
            if userIsActivated {
                return [.home, .practical, .schedule]
            } else {
                return [.home, .practical]
            }
        }()

        ZStack {
            TabView(selection: $selectedItem) {
                ForEach(tabs, id: \.self) { tab in
                    switch tab {
                    case .home:
                        ConferencePageView(namespace: namespace, isShowingMentor: $isShowingMentor)
                            .tabItem {
                                Label("Conference", systemImage: "person.3")
                                    .environment(\.symbolVariants, tab == selectedItem ? .fill : .none)
                            }
                            .tag(tab)
                    case .practical:
                        PracticalPageView(navigationPath: $practicalNavigationPath)
                            .tabItem {
                                Label("Practical", systemImage: "wallet.pass")
                                    .environment(\.symbolVariants, tab == selectedItem ? .fill : .none)
                            }
                            .tag(tab)
                    case .schedule:
                        NavigationStack {
                            ScheduleView()
                        }
                        .tabItem {
                            Label("Schedule", systemImage: "calendar.day.timeline.left")
                                .environment(\.symbolVariants, tab == selectedItem ? .fill : .none)
                        }
                        .tag(tab)
                    }
                }
            }
            .accentColor(.questionMarkColor)
        }
        .onAppear {
            handleURLTask()
        }
        .onChange(of: urlTaskTriggered) { _, _ in
            handleURLTask()
        }
        .onChange(of: appDataModel.tickets) { _, _ in
            // TODO: Open the ticket page
        }
    }


    func handleURLTask() {
        if let urlTaskTriggered {
            switch urlTaskTriggered {
            case .action(let appAction):
                switch appAction {
                case .atTheConference:
                    selectedItem = .practical
                case .atHome:
                    selectedItem = .home
                }
            case .seal:
                if !practicalNavigationPath.isEmpty {
                    practicalNavigationPath = NavigationPath()
                }
                practicalNavigationPath.append(NavigationPage.spotTheSeal)
                selectedItem = .practical
            case .contact:
                if !practicalNavigationPath.isEmpty {
                    practicalNavigationPath = NavigationPath()
                }
                practicalNavigationPath.append(NavigationPage.nfc)
                selectedItem = .practical
            case .ticket:
                if !practicalNavigationPath.isEmpty {
                    practicalNavigationPath = NavigationPath()
                }
                practicalNavigationPath.append(NavigationPage.tickets)
                selectedItem = .practical
            }
            self.urlTaskTriggered = nil
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabBarView(urlTaskTriggered: .constant(nil))
                .previewDisplayName("Light mode")
            TabBarView(urlTaskTriggered: .constant(nil))
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}


extension View {
    @inlinable
    func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self.mask(
            ZStack {
                Rectangle()

                mask()
                    .blendMode(.destinationOut)
            }
        )
    }
}
