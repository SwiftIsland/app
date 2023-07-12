//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ConferenceMentorsView: View {
    let mentors: [Mentor]
    let selectedMentor: Mentor?

    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 0){ //  to remove spacing between rows
                    ForEach(mentors){ mentor in
                        ConferenceMentorsMentorView(mentor: mentor)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .mask {
                                Rectangle()
                                    .frame(width: UIScreen.main.bounds.width)
                            }
                            .ignoresSafeArea()
                    }
                }
            }
            .onAppear {
                UIScrollView.appearance().isPagingEnabled = true
            }
            .onDisappear {
                UIScrollView.appearance().isPagingEnabled = false
            }
        }
        .ignoresSafeArea()
        .toolbarBackground(.ultraThinMaterial.opacity(0), for: .navigationBar)
        .toolbarRole(.editor)
    }
}

struct ConferenceMentorsView_Previews: PreviewProvider {
    static var previews: some View {
        let mentors = [
            Mentor.forPreview(highResImageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/swiftisland-fc283.appspot.com/o/images%2FuserHighRes%2FPaul_Peelen_3A60E527-1D64-43C1-B4AB-CBFB0B4030C7.jpeg?alt=media&token=46608fee-981a-440a-a8b1-4c280ea15d42"))
        ]

        ConferenceMentorsView(mentors: mentors, selectedMentor: nil)
    }
}
