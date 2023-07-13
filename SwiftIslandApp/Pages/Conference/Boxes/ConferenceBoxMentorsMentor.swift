//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ConferenceBoxMentorsMentor: View {
    var namespace: Namespace.ID
    let mentor: Mentor

    var body: some View {
        ZStack {
            if let url = mentor.highResImageUrl {
                VStack(alignment: .leading) {
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(mentor.firstName) \(mentor.lastName)")
                                .font(.title2)
                                .fontWeight(.light)
                                .foregroundColor(.primary)
                                .matchedGeometryEffect(id: "mentorName", in: namespace)
                                .padding(.horizontal)
                            Text(mentor.description ?? "")
                                .font(.body)
                                .lineLimit(1)
                                .foregroundColor(.boxText)
                                .hidden()
                                .matchedGeometryEffect(id: "mentorDescription", in: namespace)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.primary)
                                .padding(.trailing, 5)
                        }
                    }
                    .padding(.horizontal, 5)
                    .padding(.vertical, 10)
                    .background(.thinMaterial)
                    .matchedGeometryEffect(id: "background", in: namespace)
                }
                .background(alignment: .top) {
                    AsyncImage(
                        url: url,
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
            } else {
                LinearGradient(colors: [.gray.opacity(0.8), .white], startPoint: UnitPoint(x: 0, y: 0.1), endPoint: UnitPoint(x: 1, y: 1))
                Text("\(mentor.firstName) \(mentor.lastName)")
                    .font(.custom("WorkSans-Bold", size: 32))
            }
        }
        .mask {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
        }
    }
}

struct ConferenceBoxMentorsMentor_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        let mentor = Mentor.forPreview(highResImageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/swiftisland-fc283.appspot.com/o/images%2FuserHighRes%2FPaul_Peelen_3A60E527-1D64-43C1-B4AB-CBFB0B4030C7.jpeg?alt=media&token=46608fee-981a-440a-a8b1-4c280ea15d42"))
        ConferenceBoxMentorsMentor(namespace: namespace, mentor: mentor)
    }
}
