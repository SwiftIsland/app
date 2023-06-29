//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ConferenceHeaderView: View {
    var body: some View {
        VStack(spacing: 13) {
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
            HStack {
                Spacer()
                VStack {
                    Image("CalendarIcon")
                    VStack {
                        Text("Sept 5-6")
                            .font(.custom("WorkSans-Bold", size: 18))
                        Text("XX days left")
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
        }
    }
}

struct ConferenceHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ConferenceHeaderView()
    }
}
