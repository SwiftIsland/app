//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct ConferenceBoxMentorsWorkshop: View {
    var namespace: Namespace.ID
    @EnvironmentObject private var appDataModel: AppDataModel

    private let maxHeight: CGFloat = 300
    private let aspectRatio: CGFloat = 1.5

    var body: some View {
        VStack(alignment: .leading) {
            Text("Mentors this year".uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
                .padding(.top, 6)
                .padding(.bottom, 0)
            NavigationStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(appDataModel.mentors) { mentor in
                            NavigationLink(value: mentor) {
                                Image(mentor.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .border(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.1), width: 1)
                                    .cornerRadius(15)
                                    .aspectRatio(aspectRatio, contentMode: .fit)
                                    .frame(maxHeight: maxHeight)
                                    .overlay(
                                        ExcerptView(mentor: mentor)
                                    )
                            }
                            .aspectRatio(aspectRatio, contentMode: .fit)
                            .frame(maxHeight: maxHeight)
                            .mask {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .navigationDestination(for: Mentor.self) { mentor in
                    MentorPageView(mentor: mentor)
                }
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace

    return ConferenceBoxMentorsWorkshop(namespace: namespace)
        .environmentObject(AppDataModel())
}

private struct ExcerptView: View {
    let mentor: Mentor

    @State private var showUrl: URL?

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Rectangle()
                .frame(maxHeight: 70)
                .background(.thinMaterial)
                .overlay(
                    HStack {
                        Text(mentor.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .padding(.horizontal)
                        Spacer()
                    }
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
