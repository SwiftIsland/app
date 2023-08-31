//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct SectionBeforeYouLeave: View {
    let iconMaxWidth: CGFloat

    @EnvironmentObject private var appDataModel: AppDataModel

    var body: some View {
        Section(header: Text("Before you leave")) {
            HStack {
                Text("Make sure you are all set for a few days of awesome workshops.")
                    .font(.subheadline)
            }
            NavigationLink(value: NavigationPage.tickets) {
                HStack {
                    Image(systemName: "ticket")
                        .foregroundColor(.questionMarkColor)
                        .frame(maxWidth: iconMaxWidth)
                    Text("Tickets")
                        .dynamicTypeSize(.small ... .medium)
                }
            }
            NavigationLink(value: NavigationPage.packlist) {
                HStack {
                    Image(systemName: "suitcase.rolling")
                        .foregroundColor(.questionMarkColor)
                        .frame(maxWidth: iconMaxWidth)
                    Text("Packlist")
                        .dynamicTypeSize(.small ... .medium)
                }
            }
            if let joinSlack = appDataModel.pages.first(where: { $0.id == "joinSlack" }), let url = URL(string: joinSlack.content) {
                Button {
                    UIApplication.shared.open(url)
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

struct SectionBeforeYouLeave_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SectionBeforeYouLeave(iconMaxWidth: 32)
                .environmentObject(AppDataModel())
        }
    }
}
