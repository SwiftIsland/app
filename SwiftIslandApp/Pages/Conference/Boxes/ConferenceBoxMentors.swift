//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ConferenceBoxMentors: View {
    @Binding var mentors: [Mentor]

    var body: some View {
        VStack {
            if mentors.isEmpty {
                ProgressView()
            } else {
                GeometryReader { geo in
                    TabView {
                        ForEach(mentors) { mentor in
                            NavigationLink(value: mentor) {
                                ConferenceBoxMentorsMentor(mentor: mentor)
                                    .frame(maxWidth: geo.size.width - 40, alignment: .topLeading)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
        }
    }
}

struct ConferenceBoxMentors_Previews: PreviewProvider {
    static var previews: some View {
        let mentors = [
            Mentor.forPreview()
        ]
        ConferenceBoxMentors(mentors: .constant(mentors))
    }
}

