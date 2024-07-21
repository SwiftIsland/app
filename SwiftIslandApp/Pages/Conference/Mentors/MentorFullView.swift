//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct MentorFullView: View {
    var namespace: Namespace.ID
    let mentor: Mentor

    @Binding var isShowingContent: Bool

    var body: some View {
        ScrollViewOffset {
            VStack {
                ZStack {
                    Color.background
                        .cornerRadius(15)
                    VStack(alignment: .leading) {
                        ZStack(alignment: .bottomLeading) {
                            MentorImage(namespace: namespace, mentor: mentor)
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(mentor.name)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .foregroundStyle(.pink)
                                        .background(.white)
                                        .font(.system(size: 20))
                                        .fontWeight(.semibold)
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        if let web = mentor.webUrl {
                                            LinkButton(url: web, imageName: "web")
                                        }
                                        if let mastodon = mentor.mastodonUrl {
                                            LinkButton(url: mastodon, imageName: "mastodon")
                                        }
                                        if let linkedin = mentor.linkedInUrl {
                                            LinkButton(url: linkedin, imageName: "linkedin")
                                        }
                                        if let twitter = mentor.twitterUrl {
                                            LinkButton(url: twitter, imageName: "x")
                                        }
                                    }
                                    .padding(.trailing, 20)
                                }
                            }
                            .matchedGeometryEffect(id: "\(mentor.id)-mentorExcerptView", in: namespace)
                            .frame(maxWidth: .infinity, alignment: .bottomLeading)
                            .padding(.bottom, 18)
                            .padding(.leading, 20)
                        }
                        Text(mentor.description)
                            .foregroundColor(Color(.darkGray))
                            .font(.system(.body, design: .rounded))
                            .padding(.horizontal)
                            .padding(.vertical, 20)
                            .transition(.move(edge: .bottom))
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity)
        } onOffsetChange: { offset in
            if offset > 115 {
                dismissView()
            }
        }
        .background(.white)
    }

    func dismissView() {
        withAnimation(.interactiveSpring(response: 0.55, dampingFraction: 0.8)) {
            isShowingContent = false
        }
    }
}

#Preview {
    @Namespace var namespace
    let mentor = Mentor.forPreview()

    return ZStack {
        Color.red
        MentorFullView(namespace: namespace, mentor: mentor, isShowingContent: .constant(true))
    }
    .ignoresSafeArea()
}

private struct LinkButton: View {
    let url: URL
    let imageName: String

    @State private var showUrl: URL?

    var body: some View {
        Button(action: {
            showUrl = url
        }, label: {
            Image(imageName)
        })
        .buttonStyle(.plain)
        .padding(0)
        .foregroundColor(.red)
        .sheet(item: $showUrl) {
            showUrl = nil
        } content: { url in
            SafariWebView(url: url)
                .ignoresSafeArea()
        }
        .foregroundColor(.pink)
    }
}
