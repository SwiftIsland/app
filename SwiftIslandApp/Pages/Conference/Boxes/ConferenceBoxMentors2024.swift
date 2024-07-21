//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct ConferenceBoxMentors2024: View {
    var namespace: Namespace.ID

    @EnvironmentObject private var appDataModel: AppDataModel

    @Binding var isShowingMentor: Bool
    @Binding var mayShowMentorNextMentor: Bool
    @Binding var selectedMentor: Mentor?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Mentors this year".uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
                .padding(.top, 6)
                .padding(.bottom, 0)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(appDataModel.mentors) { mentor in
                        MentorBoxView(namespace: namespace, mentor: mentor)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.white, lineWidth: 2)
                            )
                            .background(.white)
                            .cornerRadius(20)
                            .frame(width: 224)
                            .shadow(color: .black.opacity(0.2), radius: 5)
                            .onTapGesture {
//                                if mayShowMentorNextMentor {
                                    mayShowMentorNextMentor = false
                                    selectedMentor = mentor
                                    withAnimation(.interactiveSpring(response: 0.55, dampingFraction: 0.8)) {
                                        isShowingMentor = true
                                    }
//                                } else {
//                                    debugPrint("Too soon to show next mentor animation")
//                                }
                            }
                    }
                }
                .padding(.vertical)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .safeAreaPadding(.horizontal, 20)
        }
    }
}

#Preview {
    @Namespace var namespace
    let appDataModel = AppDataModel()

    let mentors = [
        Mentor.forPreview(imageName: "speaker-paul-2024", name: "Paul Peelen"),
        Mentor.forPreview(imageName: "speaker-manu-2024", name: "Manu Carrasco Molina"),
        Mentor.forPreview(imageName: "speaker-jolanda-2024", name: "Jolanda Arends"),
    ]

    appDataModel.mentors = mentors

    return ConferenceBoxMentors2024(namespace: namespace,
                                    isShowingMentor: .constant(false),
                                    mayShowMentorNextMentor: .constant(true),
                                    selectedMentor: .constant(nil))
        .environmentObject(appDataModel)
}
