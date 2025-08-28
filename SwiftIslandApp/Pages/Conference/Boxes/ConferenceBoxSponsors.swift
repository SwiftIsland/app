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
    @State var currentSponsor: Sponsor?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Sponsors".uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
                .padding(.top, 6)
                .padding(.bottom, 0)
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(appDataModel.sponsors.filter({$0.type == .app}).sorted(by: { a, b in
                    a.name < b.name
                })) { sponsor in
                    Button {
                        currentSponsor = sponsor
                    } label: {
                        VStack {
                            RemoteImageView(
                                imagePath: sponsor.primaryImageUrl,
                                fallbackImageName: "icon-placeholder"
                            )
                            .frame(width: 70, height: 70)
                            Text(sponsor.name).font(.callout).foregroundColor(.primary)
                        }
                    }
                }
            }
            VStack {
                ForEach(appDataModel.sponsors.filter({$0.type == .book}).sorted(by: { a, b in
                    a.name < b.name
                })) { sponsor in
                    Button {
                        currentSponsor = sponsor
                    } label: {
                        VStack {
                            RemoteImageView(
                                imagePath: sponsor.primaryImageUrl,
                                fallbackImageName: "book-placeholder"
                            )
                            Text(sponsor.name).font(.callout).foregroundColor(.primary)
                        }.padding(.horizontal, 40)
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
        .sheet(item: $currentSponsor) {
            currentSponsor = nil
        } content: { sponsor in
            SafariWebView(url: sponsor.link)
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
