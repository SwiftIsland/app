//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct ConferenceBoxSponsors: View {
    @Environment(\.colorScheme)
    var colorScheme
    @EnvironmentObject private var appDataModel: AppDataModel
    @State var currentSponsor = Sponsor()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Sponsors".uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
                .padding(.top, 6)
                .padding(.bottom, 0)
            TabView(selection: $currentSponsor) {
                ForEach(appDataModel.sponsors) { sponsor in
                    VStack {
                        AsyncImage(url: sponsor.image) { image in
                            image.resizable().aspectRatio(1, contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }.frame(width: 150, height: 150)
                        Text(sponsor.title).font(.title)
                    }
                    .tag(sponsor)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .indexViewStyle(.page(backgroundDisplayMode: colorScheme == .light ? .always : .automatic))
            .frame(height: 400)
            Spacer()
        }
    }
}


struct ConferenceBoxSponsors_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        let appDataModel = AppDataModel()

        let sponsors = [
            Sponsor.forPreview(title: "Things"),
            Sponsor.forPreview(title: "OmniFocus"),
            Sponsor.forPreview(title: "Kaleidoscope")
        ]

        appDataModel.sponsors = sponsors

        return ConferenceBoxSponsors()
            .environmentObject(appDataModel)
    }
}
