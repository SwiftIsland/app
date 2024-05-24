//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import Defaults

struct ConferenceHeaderView: View {
    private let startDate = Date(timeIntervalSince1970: 1724749200)

    @Default(.userIsActivated)
    private var userIsActivated

    var body: some View {
        VStack(spacing: 13) {
            if !userIsActivated {
                Image("Logo")
                VStack(spacing: 0) {
                    Text("Swift")
                        .font(.custom("WorkSans-Bold", size: 64))
                        .foregroundColor(.logoText)
                    Text("Island")
                        .font(.custom("WorkSans-Regular", size: 60))
                        .foregroundColor(.logoText)
                        .offset(CGSize(width: 0, height: -20))
                }
            }
            HStack {
                Spacer()
                VStack {
                    Image("CalendarIcon")
                    VStack {
                        Text("Aug 27-29")
                            .font(.custom("WorkSans-Bold", size: 18))
                        Text(startDate.relativeDateDisplay())
                            .font(.custom("WorkSans-Regular", size: 14))
                    }
                }
                Spacer()
                VStack {
                    Image("LocationIcon")
                    VStack {
                        Text("Texel")
                            .font(.custom("WorkSans-Bold", size: 18))
                        Text("the Netherlands")
                            .font(.custom("WorkSans-Regular", size: 14))
                    }
                }
                Spacer()
            }
            .padding(.top, userIsActivated ? 30 : 0)
        }
    }
}

struct ConferenceHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ConferenceHeaderView()
                .preferredColorScheme(.light)
                .previewDisplayName("Light mode")
            ConferenceHeaderView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}
