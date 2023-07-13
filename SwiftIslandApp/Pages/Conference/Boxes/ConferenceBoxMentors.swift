//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ConferenceBoxMentors: View {
    var namespace: Namespace.ID

    @Binding var mentors: [Mentor]
    @Binding var isShowingMentor: Bool
    @Binding var selectedMentor: Mentor?

    var body: some View {
        VStack {
            if mentors.isEmpty {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                TabView {
                    ForEach(mentors) { mentor in
                        ConferenceBoxMentorsMentor(namespace: namespace, mentor: mentor)
                            .frame(maxWidth: UIScreen.main.bounds.width, alignment: .topLeading)
                            .onTapGesture {
                                selectedMentor = mentor
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    isShowingMentor = true
                                }
                            }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
    }
}

struct ConferenceBoxMentors_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        let mentors = [
            Mentor.forPreview(
                highResImageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/swiftisland-fc283.appspot.com/o/images%2FuserHighRes%2FPaul_Peelen_3A60E527-1D64-43C1-B4AB-CBFB0B4030C7.jpeg?alt=media&token=46608fee-981a-440a-a8b1-4c280ea15d42"))
        ]
        ConferenceBoxMentors(namespace: namespace, mentors: .constant(mentors), isShowingMentor: .constant(true), selectedMentor: .constant(nil))
    }
}

