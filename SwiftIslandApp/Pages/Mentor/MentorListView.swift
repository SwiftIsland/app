//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct MentorListView: View {
    @EnvironmentObject private var appDataModel: AppDataModel

    @State private var mentors: [Mentor] = []
    @State private var showUrl: URL?

    var body: some View {
        VStack {
            List(appDataModel.mentors) { mentor in
                NavigationLink(value: mentor) {
                    HStack {
                        Image(mentor.imageName)
                            .resizable()
                            .cornerRadius(15)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .scaledToFill()
                            .border(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.1), width: 1)
                        VStack(alignment: .leading) {
                            Text(mentor.name)
                                .font(.title)
                                .foregroundColor(.primary)
                            HStack(alignment: .center) {
                                if let web = mentor.webUrl {
                                    Button(action: {
                                        showUrl = web
                                    }, label: {
                                        Image("web")
                                    })
                                    .buttonStyle(.plain)
                                    .padding(0)
                                    .foregroundColor(.red)
                                }
                                if let mastodon = mentor.mastodonUrl {
                                    Button(action: {
                                        showUrl = mastodon
                                    }, label: {
                                        Image("mastodon")
                                    })
                                    .buttonStyle(.plain)
                                }
                                if let linkedin = mentor.linkedInUrl {
                                    Button(action: {
                                        showUrl = linkedin
                                    }, label: {
                                        Image("linkedin")
                                    })
                                    .buttonStyle(.plain)
                                }
                                if let twitter = mentor.twitterUrl {
                                    Button(action: {
                                        showUrl = twitter
                                    }, label: {
                                        Image("x")
                                    })
                                    .buttonStyle(.plain)
                                    .padding(0)
                                }
                                Spacer()
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
                .draggable(mentor)
            }
        }
        .task {
            self.mentors = appDataModel.mentors
        }
    }
}

#Preview {
    MentorListView()
        .environmentObject(AppDataModel())
}
