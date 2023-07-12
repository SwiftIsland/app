//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

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
                            .ignoresSafeArea()
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

            VStack(alignment: .leading) {
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(mentor.firstName) \(mentor.lastName)")
                        .font(.title)
                        .foregroundColor(.boxText)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment:.topLeading)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .background(.ultraThinMaterial)
                        .frame(maxWidth: .infinity)
                )
                .mask {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
        }
        .frame(width: UIScreen.main.bounds.width)
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 88)
        }
    }
}

struct ConferenceMentorsMentorView_Previews: PreviewProvider {
    static var previews: some View {
        let mentor = Mentor(userId: "",
                            firstName: "John",
                            lastName: "Appleseed",
                            userType: .mentor,
                            headerImageUrl: nil,
                            highResImageUrl:  URL(string: "https://firebasestorage.googleapis.com:443/v0/b/swiftisland-fc283.appspot.com/o/images%2FuserHighRes%2FPaul_Peelen_DB6B127E-6F9C-4508-A479-74A797855DC9.jpeg?alt=media&token=3da43de6-9fe5-4e62-88c0-72897b07edb8")!)

        Group {
            ConferenceMentorsMentorView(mentor: mentor)
                .preferredColorScheme(.light)
                .previewDisplayName("Light mode")
            ConferenceMentorsMentorView(mentor: mentor)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}
