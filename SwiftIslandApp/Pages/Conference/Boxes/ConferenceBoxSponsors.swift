//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct ConferenceBoxSponsors: View {
    @EnvironmentObject private var appDataModel: AppDataModel
    @Binding var navPath: NavigationPath
    @State var currentSponsor = Sponsor()
    private let spacing: CGFloat = 20
    private let columns = Array(repeatElement(GridItem(.flexible(minimum: 44), spacing: 20), count: 3))

    var body: some View {
        if let sponsors = appDataModel.sponsors {
            VStack(alignment: .leading) {
                Text("Sponsors".uppercased())
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 40)
                    .padding(.top, 6)
                    .padding(.bottom, 0)
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(sponsors.apps) { sponsor in
                        NavigationLink(value: sponsor) {
                            VStack {
                                AsyncImage(url: sponsor.image) { image in
                                    image.resizable().aspectRatio(1, contentMode: .fit)
                                } placeholder: {
                                    Rectangle()
                                        .fill(.ultraThinMaterial)
                                        .cornerRadius(10)
                                }
                                .frame(width: 70, height: 70)
                                Text(sponsor.title).font(.callout).foregroundColor(.primary)
                            }
                        }
                    }
                }
                if let content = sponsors.content {
                    VStack {
                        ForEach(content) { sponsor in
                            NavigationLink(value: sponsor) {
                                VStack {
                                    AsyncImage(url: sponsor.image) { image in
                                        image.resizable().aspectRatio(contentMode: .fit)
                                    } placeholder: {
                                        Rectangle()
                                            .fill(.ultraThinMaterial)
                                            .cornerRadius(10)
                                    }
                                    Text(sponsor.title).font(.callout).foregroundColor(.primary)
                                }.padding(.horizontal, 40)
                            }
                        }
                    }
                } else {
                    EmptyView()
                }
            }
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
            .navigationDestination(for: Sponsor.self) { sponsor in
                SafariWebView(url: sponsor.url) {
                    navPath.removeLast()
                }
                .navigationTitle(sponsor.title)
            }
        } else {
            EmptyView()
        }
    }
}


struct ConferenceBoxSponsors_Previews: PreviewProvider {
    @Namespace static var namespace
    @State static var navPath = NavigationPath()

    static var previews: some View {
        let appDataModel = AppDataModel()
        return ConferenceBoxSponsors(navPath: $navPath)
            .environmentObject(appDataModel)
    }
}
