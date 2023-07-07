//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ConferencePageView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.conferenceBackgroundFrom, .conferenceBackgroundTo], startPoint: UnitPoint(x: 0, y: 0.1), endPoint: UnitPoint(x: 1, y: 1))
                    .ignoresSafeArea()

                GeometryReader { geo in
                    ScrollView(.vertical) {
                        ConferenceHeaderView()
                        ConferenceBoxTicket()
                            .padding(.vertical, 6)

                        VStack(alignment: .leading) {
                            Text("Mentors this year".uppercased())
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 40)
                                .padding(.top, 6)
                                .padding(.bottom, 0)
                            ConferenceBoxMentors()
                                .frame(height: geo.size.width * 0.50)
                                .padding(.vertical, 0)
                        }

                        ConferenceBoxFAQ()
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
        }
    }
}

struct ConferencePageView_Previews: PreviewProvider {
    static var previews: some View {
        ConferencePageView()
    }
}
