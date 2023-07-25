//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import CoreLocation
import Defaults
import FirebaseFirestore

// MARK: - Main page

struct PracticalPageView: View {

    private let iconMaxWidth: CGFloat = 32
    @State private var pages: [Page] = []

    @Default(.userIsActivated) private var userIsActivated

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.defaultBackground

                List {
                    SectionBeforeYouLeave(iconMaxWidth: iconMaxWidth)

                    SectionGettingHere(iconMaxWidth: iconMaxWidth)

                    if userIsActivated {
                        SectionAtTheConference(iconMaxWidth: iconMaxWidth)
                    } else {
                        SectionAtTheConferenceNotActivated(iconMaxWidth: iconMaxWidth)
                    }
                }
                .scrollContentBackground(.hidden)
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 44)
                }
            }
            .navigationTitle("Practical")
            .navigationDestination(for: Page.self) { page in
                PracticalGenericPageView(page: page)
            }
        }
    }
}

// MARK: - Preview

struct PracticalPageView_Previews: PreviewProvider {
    static var previews: some View {
        let appDataModel = AppDataModel()
        appDataModel.pages = [
            Page(id: "schiphol", title: "", content: "", imageName: "schiphol"),
            Page(id: "joinSlack", title: "", content: "https://join.slack.com/t/swiftisland/shared_invite/abc-123-def", imageName: "")
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

// MARK: - Sub section: Before you leave

struct SectionBeforeYouLeave: View {
    let iconMaxWidth: CGFloat

    var body: some View {
        Section(header: Text("Before you leave")) {
            HStack {
                Text("Make sure you are all set for a few days of awesome workshops.")
                    .font(.subheadline)
            }
            NavigationLink(destination: {
                Text("Packlist")
            }, label: {
                HStack {
                    Image(systemName: "suitcase.rolling")
                        .foregroundColor(.questionMarkColor)
                        .frame(maxWidth: iconMaxWidth)
                    Text("Packlist")
                        .dynamicTypeSize(.small ... .medium)
                }
            })
        }
    }
}

// MARK: - Sub section: Getting here

struct SectionGettingHere: View {
    let iconMaxWidth: CGFloat

    @EnvironmentObject private var appDataModel: AppDataModel
    @State private var isShowingMapView = false
    @State private var directionSheetShowing = false

    private let pages: [SubPage] = [.hassleFree, .schiphol]

    var body: some View {
        Section(header: Text("Getting here")) {
            Button {
                isShowingMapView.toggle()
            } label: {
                VStack {
                    let location = Location(coordinate: CLLocationCoordinate2D(latitude: 53.11478763673313, longitude: 4.8972633598615065))
                    GettingThereMapView(locations: [location])
                        .padding(0)
                        .allowsHitTesting(false)
                }
                .frame(minHeight: 110)
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

            ForEach(pages, id:\.self) { subPage in
                getLink(forSubPage: subPage)
            }

            Button {
                directionSheetShowing = true
            } label: {
                HStack {
                    Image(systemName: "bicycle")
                        .foregroundColor(.questionMarkColor)
                        .frame(maxWidth: iconMaxWidth)
                    Text("Directions")
                        .dynamicTypeSize(.small ... .medium)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
        }
        .confirmationDialog("Which app would you like to use?", isPresented: $directionSheetShowing, titleVisibility: .visible) {
            Button("Apple Maps") {
                let url = URL(string: "https://maps.apple.com/?address=Stuifweg%2013,%201794%20HA%20Oosterend,%20Netherlands&auid=15837284651049995092&ll=53.114790,4.897070&lsp=9902&q=Prins%20Hendrik")!
                UIApplication.shared.open(url)
            }

            Button("Google Maps") {
                let url = URL(string: "https://www.google.com/maps/dir/Restaurant+Prins+Hendrik,+Stuifweg+13,+1794+HA+Oosterend,+Netherlands/@53.1148113,4.8946637,17z/data=!4m8!4m7!1m0!1m5!1m1!1s0x47cf337d48cfb191:0x26980e939a31392a!2m2!1d4.8972386!2d53.1148081")!
                UIApplication.shared.open(url)
            }

            Button("Waze") {
                let url = URL(string: "https://ul.waze.com/ul?place=ChIJh_hkzwszz0cRZK8on-VKmHE&ll=53.11485850%2C4.89709170&navigate=yes")!
                UIApplication.shared.open(url)
            }
        }
    }

    private func getLink(forSubPage subPage: SubPage) -> some View {
        ZStack {
            if let page = appDataModel.pages.first(where: { $0.id == subPage.firebaseId }) {
                NavigationLink(value: page) {
                    HStack {
                        subPage.icon
                            .foregroundColor(.questionMarkColor)
                            .frame(maxWidth: iconMaxWidth)
                        Text(subPage.title)
                            .dynamicTypeSize(.small ... .medium)
                    }
                }
            } else {
                VStack(alignment: .leading) {
                    Text("**Error**")
                        .font(.body)
                        .foregroundColor(.redLight)
                        .dynamicTypeSize(.medium)
                    Text("Sub page with id *`\(subPage.firebaseId)`* was not found in Firestore pages.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .dynamicTypeSize(.medium)
                }
            }
        }
    }
}

// MARK: - Sub section: At the conference

struct SectionAtTheConference: View {
    let iconMaxWidth: CGFloat
    @EnvironmentObject private var appDataModel: AppDataModel

    var body: some View {
        Section(header: Text("At the conference")) {
            HStack {
                Text("You made it! We are very happy too see you made it to the conference!")
                    .font(.subheadline)
            }
            NavigationLink(destination: {
                ScheduleView()
            }, label: {
                HStack {
                    Image(systemName: "calendar.day.timeline.leading")
                        .foregroundColor(.questionMarkColor)
                        .frame(maxWidth: iconMaxWidth)
                    Text("Checkout the schedule")
                        .dynamicTypeSize(.small ... .medium)
                }
            })
            NavigationLink(destination: {
                Text("Map")
            }, label: {
                HStack {
                    Image(systemName: "map")
                        .foregroundColor(.questionMarkColor)
                        .frame(maxWidth: iconMaxWidth)
                    Text("Map")
                        .dynamicTypeSize(.small ... .medium)
                }
            })
            if let joinSlack = appDataModel.pages.first(where: { $0.id == "joinSlack" }) {
                Button {
                    UIApplication.shared.open(URL(string: joinSlack.content)!)
                } label: {
                    HStack {
                        Image(systemName: "message")
                            .foregroundColor(.questionMarkColor)
                            .frame(maxWidth: iconMaxWidth)
                        Text("Join our Slack")
                            .dynamicTypeSize(.small ... .medium)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

// MARK: - Helper functionality

private enum SubPage {
    case hassleFree
    case schiphol

    var icon: Image {
        let systemName: String

        switch self {
        case .hassleFree:
            systemName = "ticket"
        case .schiphol:
            systemName = "airplane.arrival"
        }

        return Image(systemName: systemName)
    }

    var title: String {
        switch self {
        case .hassleFree:
            return "Hassle Free Ticket"
        case .schiphol:
            return "At Schiphol"
        }
    }

    var firebaseId: String {
        switch self {
        case .hassleFree:
            return "hassleFree"
        case .schiphol:
            return "schiphol"
        }
    }
}
