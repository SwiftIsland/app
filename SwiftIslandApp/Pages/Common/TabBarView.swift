//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import Defaults
import SwiftIslandDataLogic

// 1.1: Rename to "Tabs" instead of "Tab"
private enum Tabs {
    case home
    case practical
    case schedule
    case mentorList
    case search
    case mentors(Mentor)

    var customizationID: String {
        switch self {
        case .mentors(let mentor):
            mentor.customizationID
        default:
            "\(self.hashValue)"
        }
    }
}

extension Mentor {
    var customizationID: String {
        "SwiftIsland.mentor." + self.name
    }
}

extension Tabs: Hashable {
    var id: String {
        switch self {
        case .home: "home"
        case .practical: "practical"
        case .schedule: "schedule"
        case .mentorList: "mentorList"
        case .mentors(let mentor): mentor.id
        case .search: "search"
        }
    }
}

struct TabBarView: View {
    @Namespace private var namespace
    @State private var selectedItem: Tabs = .home
    @Binding var appActionTriggered: AppActions?

    @State private var isShowingMentor = false
    @EnvironmentObject private var appDataModel: AppDataModel

    @AppStorage("sidebarCustomizations") var tabViewCustomization: TabViewCustomization

    @State private var favoriteMentors: [Mentor] = []

    @State var mentorPath: NavigationPath = .init()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @Default(.userIsActivated)
    private var userIsActivated

    var body: some View {
        ZStack {
            // 1.2. Update syntax to use Tab in TabView
            TabView(selection: $selectedItem) {
                Tab("Conference", systemImage: "person.3", value: .home) {
                    NavigationStack {
                        ConferencePageView(namespace: namespace, isShowingMentor: $isShowingMentor)
                            .navigationDestination(for: Mentor.self) { mentor in
                                MentorPageView(mentor: mentor)
                                    .navigationTransition(.zoom(sourceID: mentor.id, in: namespace))
                            }
                    }
                }
                .customizationBehavior(.disabled, for: .sidebar, .tabBar)

                Tab("Practical", systemImage: "wallet.pass", value: .practical) {
                    PracticalPageView()
                }
                .customizationID(Tabs.practical.customizationID)

                Tab("Schedule", systemImage: "calendar.day.timeline.left", value: .schedule) {
                    NavigationStack {
                        ScheduleView()
                    }
                }
                .customizationID(Tabs.schedule.customizationID)
                .badge(2)

                Tab(value: .search, role: .search) {
                    MentorListView()
                }

                // 2.0 Add Mentor tab
                //                if UIDevice.current.userInterfaceIdiom != .phone {
                //                    Tab("Mentors", systemImage: "graduationcap", value: .mentors) {
                //                        NavigationStack(path: $mentorPath) {
                //                            MentorListView()
                //                                .environmentObject(appDataModel)
                //                                .navigationDestination(for: Mentor.self) { mentor in
                //                                    MentorPageView(mentor: mentor)
                //                                }
                //                        }
                //                    }
                //                }

                // 2.1 Add mentor section

            TabSection {
                ForEach(appDataModel.mentors) { mentor in
                    Tab(mentor.name, systemImage: "graduationcap", value: Tabs.mentors(mentor)) {
                        NavigationStack(path: $mentorPath) {
                            MentorPageView(mentor: mentor)
                        }
                    }
                    .customizationID(mentor.customizationID)

                }
            } header: {
                Label("Mentors", systemImage: "graduationcap")
            }
            .defaultVisibility(.hidden, for: .tabBar)
            .customizationID("mentorList")
            .sectionActions {
                Button {
                    tabViewCustomization.resetSectionOrder()
                } label: {
                    Label("Reset Section Order", systemImage: "arrow.counterclockwise")
                }

                Button {
                    tabViewCustomization.resetVisibility()
                } label: {
                    Label("Reset Visibility", systemImage: "arrow.counterclockwise")
                }
            }
            .hidden(horizontalSizeClass == .compact)

                TabSection {
                    ForEach(favoriteMentors) { mentor in
                        Tab(mentor.name, systemImage: "graduationcap", value: Tabs.mentors(mentor)) {
                            NavigationStack(path: $mentorPath) {
                                MentorPageView(mentor: mentor)
                            }
                        }
                        .customizationID("favMentor.\(mentor.customizationID)")
                        .defaultVisibility(.hidden, for: .tabBar)
                    }

                    Tab("Mentor list", systemImage: "graduationcap", value: .mentorList) {
                        NavigationStack {
                            MentorListView()
                        }
                    }
                    .customizationID(Tabs.mentorList.customizationID)
                    .customizationBehavior(.disabled, for: .sidebar, .tabBar)
                    .defaultVisibility(.hidden, for: .tabBar)
                } header: {
                    Label("Favorite mentors", systemImage: "heart")
                }
                .defaultVisibility(.hidden, for: .tabBar)
                .customizationID("favoriteMentorList")
                .dropDestination(for: Mentor.self) { mentors in
                    favoriteMentors.append(contentsOf: mentors)
                }
                .hidden(horizontalSizeClass == .compact)
            }
            // 1.3 Enable sidebar¶
            .tabViewStyle(.sidebarAdaptable)
            .tabViewCustomization($tabViewCustomization)
            .tabViewSidebarHeader {
                Image("Logo")
                VStack(spacing: 0) {
                    Text("Swift")
                        .font(.custom("WorkSans-Bold", size: 64))
                        .foregroundColor(.logoText)
                    Text("Island")
                        .font(.custom("WorkSans-Regular", size: 60))
                        .foregroundColor(.logoText)
                        .offset(CGSize(width: 0, height: -20))
                }
            }
            .tabViewSidebarFooter {
                VStack(spacing: 8) {
                    Button {
                        tabViewCustomization.resetVisibility()
                        tabViewCustomization.resetSectionOrder()
                    } label: {
                        Text("Reset sidebar")
                            .font(.footnote)
                    }

                    Text("App version: \(Bundle.main.appVersionLong) (\(Bundle.main.appBuild))")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .onAppear {
            handleAppAction()
        }
        .onChange(of: appActionTriggered) { _, _ in
            handleAppAction()
        }
        .onChange(of: appDataModel.tickets) { _, _ in
            // TODO: Open the ticket page
        }
    }


    func handleAppAction() {
        if let appActionTriggered {
            switch appActionTriggered {
            case .atTheConference:
                selectedItem = .practical
            case .atHome:
                selectedItem = .home
            }

            self.appActionTriggered = nil
        }
    }
}

extension Mentor: @retroactive Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .content)
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabBarView(appActionTriggered: .constant(nil))
                .previewDisplayName("Light mode")
                .environmentObject(AppDataModel())
            TabBarView(appActionTriggered: .constant(nil))
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
                .environmentObject(AppDataModel())
            TabBarView(appActionTriggered: .constant(nil))
                .previewDisplayName("iPhone 15 Pro max")
                .previewDevice("iPhone 15 Pro Max")
                .environmentObject(AppDataModel())
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
