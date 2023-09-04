//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import CoreLocation

private enum SubPage {
    case hassleFree
    case schiphol
    case travel

    var icon: Image {
        let systemName: String

        switch self {
        case .hassleFree:
            systemName = "ticket"
        case .schiphol:
            systemName = "airplane.arrival"
        case .travel:
            systemName = "backpack"
        }

        return Image(systemName: systemName)
    }

    var title: String {
        switch self {
        case .hassleFree:
            return "Hassle Free Ticket"
        case .schiphol:
            return "At Schiphol"
        case .travel:
            return "Travel instructions"
        }
    }

    var firebaseId: String {
        switch self {
        case .hassleFree:
            return "hassleFree"
        case .schiphol:
            return "schiphol"
        case .travel:
            return "travel"
        }
    }
}

struct SectionGettingHere: View {
    let iconMaxWidth: CGFloat

    @EnvironmentObject private var appDataModel: AppDataModel

    @Binding var navPath: NavigationPath

    @State private var isShowingMapView = false
    @State private var directionSheetShowing = false

    private let pages: [SubPage] = [.hassleFree, .schiphol, .travel]

    var body: some View {
        Section(header: Text("Getting here")) {
            Button {
                navPath.append(NavigationPage.map)
            } label: {
                VStack {
                    let location = GettingThereLocation(coordinate: CLLocationCoordinate2D(latitude: 53.11478763673313, longitude: 4.8972633598615065))
                    GettingThereMapView(locations: [location])
                        .padding(0)
                        .allowsHitTesting(false)
                        .onTapGesture {
                            debugPrint("")
                        }
                }
                .frame(minHeight: 110)
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

            ForEach(pages, id: \.self) { subPage in
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
                let url = URL(string: "https://maps.apple.com/?address=Stuifweg%2013,%201794%20HA%20Oosterend,%20Netherlands&auid=15837284651049995092&ll=53.114790,4.897070&lsp=9902&q=Prins%20Hendrik")! // swiftlint:disable:this force_unwrapping
                UIApplication.shared.open(url)
            }
            .textCase(.none)

            Button("Google Maps") {
                let url = URL(string: "https://www.google.com/maps/dir//Hotel+%26+Bungalowpark+Prins+Hendrik,+Stuifweg+13,+1794+HA+Oosterend,+Netherlands/@53.1148617,4.8945168,17z/data=!4m8!4m7!1m0!1m5!1m1!1s0x47cf330bcf64f887:0x71984ae59f28af64!2m2!1d4.8972431!2d53.1148524?entry=ttu")! // swiftlint:disable:this force_unwrapping
                UIApplication.shared.open(url)
            }
            .textCase(.none)

            Button("Waze") {
                let url = URL(string: "https://ul.waze.com/ul?place=ChIJh_hkzwszz0cRZK8on-VKmHE&ll=53.11485850%2C4.89709170&navigate=yes")! // swiftlint:disable:this force_unwrapping
                UIApplication.shared.open(url)
            }
            .textCase(.none)
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

struct SectionGettingHere_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SectionGettingHere(iconMaxWidth: 32, navPath: .constant(NavigationPath()))
                .environmentObject(AppDataModel())
        }
    }
}
