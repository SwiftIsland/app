//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct ConferenceBoxMentors: View {
    var namespace: Namespace.ID

    let geo: GeometryProxy

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
                LazyHStack {
                    ForEach(appDataModel.mentors) { mentor in
                        MentorView(namespace: namespace, mentor: mentor, isShowContent: $isShowingMentor)
                            .matchedGeometryEffect(id: mentor.id, in: namespace)
                            .mask {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                            }
                            .padding(.horizontal, 20)
                            .onTapGesture {
                                if mayShowMentorNextMentor {
                                    mayShowMentorNextMentor = false
                                    selectedMentor = mentor
                                    withAnimation(.interactiveSpring(response: 0.55, dampingFraction: 0.8)) {
                                        isShowingMentor = true
                                    }
                                } else {
                                    debugPrint("Too soon to show next mentor animation")
                                }
                            }
                            .frame(width: geo.size.width * 0.8)
                            .frame(minHeight: geo.size.width * 0.80)
                    }
                }
            }
            .frame(minHeight: geo.size.width * 0.80)
        }
    }
}

struct ConferenceBoxMentors_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        let appDataModel = AppDataModel()

        let mentors = [
            Mentor.forPreview(name: "1"),
            Mentor.forPreview(name: "2"),
            Mentor.forPreview(name: "3")
        ]

        appDataModel.mentors = mentors

        return GeometryReader { geo in
            ConferenceBoxMentors(namespace: namespace, geo: geo, isShowingMentor: .constant(false), mayShowMentorNextMentor: .constant(true), selectedMentor: .constant(nil))
                .environmentObject(appDataModel)
        }
    }
}
