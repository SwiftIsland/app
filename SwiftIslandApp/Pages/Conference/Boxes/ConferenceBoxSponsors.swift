//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct ConferenceBoxSponsors: View {
    @EnvironmentObject private var appDataModel: AppDataModel
    private let spacing: CGFloat = 20
    private let columns = Array(repeatElement(GridItem(.flexible(minimum: 44), spacing: 20), count: 3))
    @State private var currentSponsor: Sponsor?

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
                        Button {
                            currentSponsor = sponsor
                        } label: {
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
                            Button {
                                currentSponsor = sponsor
                            } label: {
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
            .sheet(item: $currentSponsor) {
                currentSponsor = nil
            } content: { sponsor in
                SafariWebView(url: sponsor.url)
            }
        } else {
            EmptyView()
        }
    }
}


struct ConferenceBoxSponsors_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        let appDataModel = AppDataModel()
        return ConferenceBoxSponsors()
            .environmentObject(appDataModel)
    }
}
