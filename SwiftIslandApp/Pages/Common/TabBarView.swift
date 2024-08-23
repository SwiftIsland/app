//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import Defaults
import SwiftIslandDataLogic

private enum Tabs {
    case home
    case practical
    case schedule
    case mentors(Mentor)
    case search
    case mentorList

    var customizationID: String {
        switch self {
        case .mentors(let mentor):
            mentor.customizationID
        default:
            "SwiftIsland.\(self.hashValue)"
        }
    }
}

extension Mentor {
    var customizationID: String {
        "SwiftIsland.Mentor.\(self.name)"
    }
}

extension Tabs: Hashable {
    var id: String {
        switch self {
        case .home:
            "home"
        case .practical:
            "practical"
        case .schedule:
            "schedule"
        case .search:
            "search"
        case .mentorList:
            "mentorList"
        case .mentors(let mentor):
            mentor.id
        }
    }
}

struct TabBarView: View {
    @Namespace private var namespace
    @State private var selectedItem: Tabs = .home
    @Binding var appActionTriggered: AppActions?

    @State private var isShowingMentor = false
    @EnvironmentObject private var appDataModel: AppDataModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State var mentorPath: NavigationPath = .init()

    @State private var favoriteMentors: [Mentor] = []

    @Default(.userIsActivated)
    private var userIsActivated

    @AppStorage("sidebarCustomizations") var tabViewCustomization: TabViewCustomization

    var body: some View {
        ZStack {
            TabView(selection: $selectedItem) {
                Tab("Conference", systemImage: "person.3", value: .home) {
                    ConferencePageView(namespace: namespace, isShowingMentor: $isShowingMentor)
                }
                Tab("Practical", systemImage: "wallet.pass", value: .practical) {
                    PracticalPageView()
                }
                .customizationID(Tabs.practical.customizationID)
                Tab("Schedule", systemImage: "calendar", value: .schedule) {
                    NavigationStack {
                        ScheduleView()
                    }
                }
                .customizationID(Tabs.schedule.customizationID)
                Tab(value: .search, role: .search) {
                    MentorListView()
                }
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
                .hidden(horizontalSizeClass == .compact)

                TabSection {
                    ForEach(favoriteMentors) { mentor in
                        Tab(mentor.name, systemImage: "graduationcap", value: Tabs.mentors(mentor)) {
                            NavigationStack(path: $mentorPath) {
                                MentorPageView(mentor: mentor)
                            }
                        }
                        .customizationID("favMentor.\(mentor.customizationID)")
                    }

                    Tab("Mentor list", systemImage: "graduationcap", value: .mentorList) {
                        NavigationStack {
                            MentorListView()
                        }
                    }
                    .customizationBehavior(.disabled, for: .sidebar, .tabBar)
                } header: {
                    Label("My favorite mentors", systemImage: "heart")
                }
                .customizationID(Tabs.mentorList.customizationID)
                .dropDestination(for: Mentor.self) { mentors in
                    favoriteMentors.append(contentsOf: mentors)
                }
                .defaultVisibility(.hidden, for: .tabBar)
                .badge(favoriteMentors.count)
                .hidden(horizontalSizeClass == .compact)
            }
            .tabViewCustomization($tabViewCustomization)
            .accentColor(.questionMarkColor)
            .tabViewStyle(.sidebarAdaptable)
            .tabViewSidebarHeader {
                Image("Logo")
                VStack {
                    Text("Swift")
                        .font(.custom("WorkSans-Bold", size: 64))
                    Text("Island")
                        .font(.custom("WorkSans-Regular", size: 60))
                        .offset(y: -20)

                }
                .foregroundStyle(.logoText)
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

                    Text("App version \(Bundle.main.appVersionLong) (\(Bundle.main.appBuild))")
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

extension Mentor: @retroactive Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .content)
    }
}
