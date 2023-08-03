//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import CoreLocation
import Defaults
import SwiftIslandDataLogic

// MARK: - Main page

enum NavigationPage {
    case map
    case schedule
    case packlist
}

struct PracticalPageView: View {

    private let iconMaxWidth: CGFloat = 32
    @State private var pages: [Page] = []
    @State private var navigationPath = NavigationPath()

    @Default(.userIsActivated) private var userIsActivated

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                LinearGradient.defaultBackground

                List {
                    SectionBeforeYouLeave(iconMaxWidth: iconMaxWidth)

                    SectionGettingHere(iconMaxWidth: iconMaxWidth, navPath: $navigationPath)

                    if userIsActivated {
                        SectionAtTheConference(iconMaxWidth: iconMaxWidth, navPath: $navigationPath)
                    } else {
                        SectionAtTheConferenceNotActivated(iconMaxWidth: iconMaxWidth)
                    }
                }
                .scrollContentBackground(.hidden)
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: UIDevice.current.hasNotch ? 88 : 66)
                }
            }
            .navigationTitle("Practical")
            .navigationDestination(for: Page.self) { page in
                PracticalGenericPageView(page: page)
            }
            .navigationDestination(for: NavigationPage.self) { subPage in
                switch subPage {
                case .map:
                    MapView()
                case .schedule:
                    ScheduleView()
                case .packlist:
                    PacklistView()
                }
            }
        }
        .tint(.questionMarkColor)
    }
}

// MARK: - Preview

struct PracticalPageView_Previews: PreviewProvider {
    static var previews: some View {
        let appDataModel = AppDataModel()
        appDataModel.pages = [
            Page.forPreview(id: "schiphol", imageName: "schiphol"),
            Page.forPreview(id: "joinSlack", content: "https://join.slack.com/t/swiftisland/shared_invite/abc-123-def", imageName: "")
        ]

        return Group {
            PracticalPageView()
                .previewDisplayName("Light mode")
                .environmentObject(appDataModel)
            PracticalPageView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
                .environmentObject(appDataModel)
        }
    }
}

// MARK: - Sub section: At the conference

struct SectionAtTheConference: View {
    let iconMaxWidth: CGFloat
    @EnvironmentObject private var appDataModel: AppDataModel

    @Binding var navPath: NavigationPath

    var body: some View {
        Section(header: Text("At the conference")) {
            HStack {
                Text("You made it! We are very happy too see you made it to the conference!")
                    .font(.subheadline)
            }
            NavigationLink(value: NavigationPage.schedule) {
                HStack {
                    Image(systemName: "calendar.day.timeline.leading")
                        .foregroundColor(.questionMarkColor)
                        .frame(maxWidth: iconMaxWidth)
                    Text("Checkout the schedule")
                        .dynamicTypeSize(.small ... .medium)
                }
            }
        }
    }
}

// MARK: - Helper functionality
