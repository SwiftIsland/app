//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ConferenceBoxMentorsMentor: View {
    let mentor: Mentor

    var body: some View {
        ZStack {
            if let url = mentor.headerImageUrl {
                VStack(alignment: .leading) {
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(mentor.firstName) \(mentor.lastName)")
                                .font(.title2)
                                .fontWeight(.light)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.primary)
                                .padding(.trailing, 5)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 10)
                    .background(.thinMaterial)
                }
                .background {
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
                                .aspectRatio(contentMode: .fill)
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
    static var previews: some View {
        let mentor = Mentor.forPreview(headerImageUrl: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/swiftisland-fc283.appspot.com/o/images%2FuserHeaders%2FF701EB5B-6B98-4F0E-B99D-5F59E55C3B45.jpeg?alt=media&token=8df7a837-e378-41ce-aeb7-c1e70f70d9e1"))
        ConferenceBoxMentorsMentor(mentor: mentor)
    }
}
