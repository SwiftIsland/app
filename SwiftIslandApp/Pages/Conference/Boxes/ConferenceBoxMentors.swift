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
                Text("Fetching mentors")
            } else {
                GeometryReader { geo in
                    TabView {
                        ForEach(mentors) { mentor in
                            ZStack {
                                Button(action: {
                                    debugPrint("Do something")
                                }, label: {
                                    NavigationLink(value: mentor) {
                                        ConferenceBoxMentorsMentor(mentor: mentor)
                                            .frame(maxWidth: geo.size.width - 40, alignment: .topLeading)
                                    }
                                })
                            }
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
            Mentor(userId: "1", firstName: "John", lastName: "Appleseed", userType: .mentor, headerImageUrl: nil)
        ]
        ConferenceBoxMentors(mentors: .constant(mentors))
    }
}

