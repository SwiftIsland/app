//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import CoreLocation
import Defaults
import SwiftIslandDataLogic
import AckGenUI

// MARK: - Main page

enum NavigationPage {
    case map
    case schedule
    case packlist
    case acknowledgement
    case source
    case tickets
    case spotTheSeal
}

struct PracticalPageView: View {
    private let iconMaxWidth: CGFloat = 32
    @State private var pages: [Page] = []
    @State private var navigationPath = NavigationPath()

    @Default(.userIsActivated)
    private var userIsActivated

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

                    Section {
                        NavigationLink(value: NavigationPage.acknowledgement) {
                            HStack(alignment: .top) {
                                Image(systemName: "medal")
                                    .foregroundColor(.questionMarkColor)
                                    .frame(maxWidth: iconMaxWidth)
                                VStack(alignment: .leading) {
                                    Text("Acknowledgements")
                                        .padding(2)
                                        .foregroundColor(.primary)
                                        .dynamicTypeSize(.medium ... .accessibility1)
                                        .buttonStyle(.plain)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        NavigationLink(value: NavigationPage.source) {
                            HStack(alignment: .top) {
                                Image("github-icon")
                                    .resizable()
                                    .aspectRatio(CGSize(width: 334, height: 344), contentMode: .fit)
                                    .frame(maxWidth: iconMaxWidth * 0.7)
                                    .foregroundColor(.questionMarkColor)
                                    .frame(maxWidth: iconMaxWidth)
                                VStack(alignment: .leading) {
                                    Text("Source code")
                                        .padding(2)
                                        .foregroundColor(.primary)
                                        .dynamicTypeSize(.medium ... .accessibility1)
                                        .buttonStyle(.plain)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        Link(destination: URL(string: "https://apps.apple.com/app/id1468876096?action=write-review")!) { // swiftlint:disable:this force_unwrapping
                            HStack(alignment: .center) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.questionMarkColor)
                                    .frame(maxWidth: iconMaxWidth)
                                VStack(alignment: .leading) {
                                    Text("Rate the Swift Island app")
                                        .padding(2)
                                        .foregroundColor(.primary)
                                        .dynamicTypeSize(.medium ... .accessibility1)
                                        .buttonStyle(.plain)
                                }
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .foregroundColor(.secondary)
                                    .font(.footnote)
                            }
                            .buttonStyle(.plain)
                        }
                    } header: {
                        Text("App")
                    } footer: {
                        Text("App version: \(Bundle.main.appVersionLong) (\(Bundle.main.appBuild))")
                            .dynamicTypeSize(.small ... .medium)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Practical")
            .navigationDestination(for: Page.self) { page in
                PracticalGenericPageView(page: page)
            }
            .navigationDestination(for: Ticket.self) { ticket in
                TicketEditView(ticket: ticket)
            }
            .navigationDestination(for: NavigationPage.self) { subPage in
                switch subPage {
                case .map:
                    MapView()
                case .schedule:
                    ScheduleView()
                case .tickets:
                    TicketsView()
                case .packlist:
                    PacklistView()
                case .acknowledgement:
                    ZStack {
                        LinearGradient.defaultBackground
                        AcknowledgementsList()
                            .navigationTitle("#CreditsPageTitle")
                            .scrollContentBackground(.hidden)
                    }
                case .source:
                    SourceView()
                case .spotTheSeal:
                    PuzzlePageView()
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
            Page.forPreview(id: "joinSlack", content: "https://join.slack.com/t/swiftisland/shared_invite/abc-123-def", imageName: ""),
            Page.forPreview(id: "codeOfConduct", content: "Code of conduct", imageName: "")
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

    @Default(.puzzleStatus)
    private var puzzleStatus

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
            if let codeOfConduct = appDataModel.pages.first(where: { $0.id == "codeOfConduct" }) {
                NavigationLink(value: codeOfConduct) {
                    HStack {
                        Image(systemName: "text.book.closed")
                            .foregroundColor(.questionMarkColor)
                            .frame(maxWidth: iconMaxWidth)
                        Text("Code of Conduct")
                            .dynamicTypeSize(.small ... .medium)
                    }
                }
            }
            if !puzzleStatus.isEmpty {
                NavigationLink(value: NavigationPage.spotTheSeal) {
                    HStack {
                        Image("seal")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.questionMarkColor)
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: iconMaxWidth)
                        Text("Spot the Seal")
                            .dynamicTypeSize(.small ... .medium)
                    }
                }
            }
        }
    }
}

// MARK: - Helper functionality
