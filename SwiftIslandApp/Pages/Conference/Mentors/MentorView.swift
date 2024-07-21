//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct MentorView: View {
    var namespace: Namespace.ID
    let mentor: Mentor

    @Binding var isShowContent: Bool
    @State private var offset: CGSize = .zero

    var body: some View {
        ScrollView {
            HStack {
                
            }
        }
    }
}

extension URL: Identifiable {
    public var id: String {
        absoluteString
    }
}

#Preview("No content") {
    @Namespace var namespace
    let mentor = Mentor.forPreview()

    return MentorView(namespace: namespace, mentor: mentor, isShowContent: .constant(false))
        .previewDisplayName("No content")

    return Group {

        MentorView(namespace: namespace, mentor: mentor, isShowContent: .constant(true))
            .coordinateSpace(name: "Show content")
            .ignoresSafeArea()
    }
}

#Preview("Show content") {
    @Namespace var namespace
    let mentor = Mentor.forPreview()

    return MentorView(namespace: namespace, mentor: mentor, isShowContent: .constant(true))
        .coordinateSpace(name: "Show content")
        .ignoresSafeArea()
}

struct MentorExcerptView: View {
    var namespace: Namespace.ID
    let mentor: Mentor

    @Binding var isShowContent: Bool
    @State private var showUrl: URL?

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Rectangle()
                .frame(minHeight: 60, maxHeight: isShowContent ? 120 : 60)
                .background(.thinMaterial.opacity(isShowContent ? 0 : 1))
                .background(isShowContent ? Color.background : .clear)
                .overlay(
                    HStack {
                        Text(mentor.name)
                            .font(.title2)
                            .fontWeight(isShowContent ? .bold : .light)
                            .foregroundColor(.primary)
                            .minimumScaleFactor(0.1)
                            .lineLimit(2)
                            .padding(.bottom, isShowContent ? 5 : 0)
                        Spacer()
                        HStack {
                            if isShowContent {
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
                        }
                        .foregroundColor(.primary)
                    }
                        .matchedGeometryEffect(id: "\(mentor.name)-headline", in: namespace)
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
