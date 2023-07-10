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
    }
}

struct ConferenceMentorsView_Previews: PreviewProvider {
    static var previews: some View {
        let mentors = [
            Mentor(userId: "1", firstName: "John", lastName: "Appleseed", userType: .mentor, headerImageUrl: nil, highResImageUrl: nil)
        ]

        ConferenceMentorsView(mentors: mentors, selectedMentor: nil)
    }
}

struct ConferenceMentorsMentorView: View {
    let mentor: Mentor

    var body: some View {
        ZStack {
            if let highResImageUrl = mentor.highResImageUrl {
                AsyncImage(
                    url: highResImageUrl,
                    transaction: Transaction(animation: .easeInOut)
                ) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width)
                    case .failure:
                        Image(systemName: "wifi.slash")
                            .foregroundColor(.secondary)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Text("No high-res image for \(mentor.firstName)")
            }
        }
        .frame(width: UIScreen.main.bounds.width)
    }
}
