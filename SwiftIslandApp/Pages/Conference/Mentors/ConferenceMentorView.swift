//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ConferenceMentorView: View {
    var namespace: Namespace.ID
    @Binding var mentor: Mentor
    @Binding var isShowingMentor: Bool

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(mentor.firstName) \(mentor.lastName)")
                        .font(.title)
                        .fontWeight(.light)
                        .foregroundColor(.boxText)
                        .matchedGeometryEffect(id: "mentorName", in: namespace)
                    if let description = mentor.description {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.boxText)
                            .matchedGeometryEffect(id: "mentorDescription", in: namespace)
                    }
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
                .matchedGeometryEffect(id: "background", in: namespace)
            }

            Button("Close") {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isShowingMentor = false
                }
            }
        }
        .background(alignment: .top) {
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
                            .scaledToFill()
                            .matchedGeometryEffect(id: "mentorImage", in: namespace)
                    case .failure:
                        Image(systemName: "wifi.slash")
                            .foregroundColor(.secondary)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        .mask {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
        }
        .safeAreaInset(edge: .top, content: {
            Color.clear.frame(height: 66)
        })
        .ignoresSafeArea()
    }
}

struct ConferenceMentorsMentorView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        let mentor = Mentor.forPreview(highResImageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/swiftisland-fc283.appspot.com/o/images%2FuserHighRes%2FPaul_Peelen_3A60E527-1D64-43C1-B4AB-CBFB0B4030C7.jpeg?alt=media&token=46608fee-981a-440a-a8b1-4c280ea15d42")!, description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum ac nisl aliquam, eleifend elit sit amet, dignissim nibh. Vivamus vestibulum pretium augue, sed tincidunt orci sagittis quis. Donec auctor arcu et neque cursus, nec vulputate odio aliquet. Integer consequat sagittis lectus sed maximus. Nam et ex vel tellus lobortis tempus. Aliquam ultricies tincidunt turpis at finibus. Fusce vestibulum egestas nisl nec tincidunt. Morbi sit amet rutrum libero. Vivamus sit amet ex est. In eleifend varius mattis.")

        Group {
            ConferenceMentorView(namespace: namespace, mentor: .constant(mentor), isShowingMentor: .constant(false))
                .preferredColorScheme(.light)
                .previewDisplayName("Light mode")
            ConferenceMentorView(namespace: namespace, mentor: .constant(mentor), isShowingMentor: .constant(false))
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}
