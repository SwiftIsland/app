//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct MentorPageView: View {
    let mentor: Mentor

    @State private var offset: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                // Hack for having the bottom of the scrollview not show the view behind... need to find a better solution when there is time.
                Color.background
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(CGSize(width: 0, height: geometry.size.height / 2))
                ScrollView {
                    ZStack {
                        Color.background
                            .cornerRadius(15)
                        VStack(alignment: .leading) {
                            Image(mentor.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.6)
                                .border(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.1), width: 0)
                                .cornerRadius(15)
                                .overlay(
                                    ExcerptView(mentor: mentor)
                                )
                            // Content
                            Text(mentor.description)
                                .foregroundColor(Color(.darkGray))
                                .font(.system(.body, design: .rounded))
                                .padding(.horizontal)
                                .padding(.bottom, 20)
                                .transition(.move(edge: .bottom))
                        }
                    }
                }
            }
        }
        .onAppear {
            debugPrint("Mentor: \(mentor)")
        }
        .navigationTitle(mentor.name)
        .navigationBarTitleDisplayMode(.inline)
//        .toolbarVisibility(.hidden, for: .navigationBar)
    }
}

#Preview("No content") {
    @Previewable @Namespace var namespace
    let mentor = Mentor.forPreview()

    return MentorView(namespace: namespace, mentor: mentor, isShowContent: .constant(true))
        .ignoresSafeArea()
        .coordinateSpace(name: "Show content")
}

#Preview("Show content") {
    @Previewable @Namespace var namespace
    let mentor = Mentor.forPreview()

    return MentorView(namespace: namespace, mentor: mentor, isShowContent: .constant(true))
        .coordinateSpace(name: "Show content")
        .ignoresSafeArea()
}

private struct ExcerptView: View {
    let mentor: Mentor

    @State private var showUrl: URL?

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Rectangle()
                .frame(minHeight: 60, maxHeight: 120)
                .background(Color.background)
                .overlay(
                    HStack {
                        Text(mentor.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .minimumScaleFactor(0.1)
                            .lineLimit(2)
                            .padding(.bottom, 5)
                        Spacer()
                        HStack {
                            Spacer()
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
                        }
                        .foregroundColor(.primary)
                    }
                        .padding(.horizontal)
                )
        }
        .foregroundColor(.clear)
        .sheet(item: $showUrl) {
            showUrl = nil
        } content: { url in
            SafariWebView(url: url)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    MentorPageView(mentor: Mentor.forPreview())
}
