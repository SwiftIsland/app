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
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                // Hack for having the bottom of the scrollview not show the view behind... need to find a better solution when there is time.
                Color.background
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(CGSize(width: 0, height: geometry.size.height / 2))
                ScrollViewOffset {
                    ZStack {
                        Color.background
                            .cornerRadius(15)
                        VStack(alignment: .leading) {
                            if let uiImage = UIImage(named: mentor.imageName) { // UIImage only needed for getting the size of the image
                                Image(mentor.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width, height: isShowContent ? geometry.size.height * 0.6 : min(uiImage.size.height / 4, geometry.size.height))
                                    .border(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), width: isShowContent ? 0 : 1)
                                    .cornerRadius(15)
                                    .overlay(
                                        MentorExcerptView(namespace: namespace, headline: "\(mentor.name)", isShowContent: $isShowContent)
                                            .cornerRadius(isShowContent ? 0 : 15)
                                            .offset(CGSize(width: 0, height: !isShowContent ? 10 : 0))
                                            .matchedGeometryEffect(id: "\(mentor.id)-mentorExcerptView", in: namespace)
                                    )
                                    .matchedGeometryEffect(id: "\(mentor.id)-imageName", in: namespace)
                            }
                            // Content
                            if isShowContent {
                                Text(mentor.description)
                                    .foregroundColor(Color(.darkGray))
                                    .font(.system(.body, design: .rounded))
                                    .padding(.horizontal)
                                    .padding(.bottom, 20)
                                    .transition(.move(edge: .bottom))
                            }
                        }
                    }
                } onOffsetChange: { offset in
                    if offset > 115 {
                        dismissView()
                    }
                }
                .scrollDisabled(!isShowContent)

                // Close button
                if isShowContent {
                    HStack {
                        Spacer()

                        Button {
                            dismissView()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 26))
                                .foregroundColor(.background)
                                .opacity(0.7)
                        }
                    }
                    .padding(.top, 50)
                    .padding(.trailing)
                }
            }
        }
    }

    func dismissView() {
        withAnimation(.interactiveSpring(response: 0.55, dampingFraction: 0.8)) {
            isShowContent = false
        }
    }
}

struct MentorView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        let mentor = Mentor.forPreview()

        Group {
            MentorView(namespace: namespace, mentor: mentor, isShowContent: .constant(false))
                .previewDisplayName("No content")
            MentorView(namespace: namespace, mentor: mentor, isShowContent: .constant(true))
                .coordinateSpace(name: "Show content")
        }
    }
}

struct MentorExcerptView: View {
    var namespace: Namespace.ID
    let headline: String

    @Binding var isShowContent: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Rectangle()
                .frame(minHeight: 60, maxHeight: isShowContent ? 120 : 60)
                .background(.thinMaterial.opacity(isShowContent ? 0 : 1))
                .background(isShowContent ? Color.background : .clear)
                .overlay(
                    HStack {
                        VStack(alignment: .leading) {
                            Text(headline)
                                .font(.title2)
                                .fontWeight(isShowContent ? .bold : .light)
                                .foregroundColor(.primary)
                                .minimumScaleFactor(0.1)
                                .lineLimit(2)
                                .padding(.bottom, isShowContent ? 5 : 0)
                                .matchedGeometryEffect(id: "\(headline)-headline", in: namespace)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)

                        Spacer()
                    }
            )
        }
        .foregroundColor(.clear)
    }
}
