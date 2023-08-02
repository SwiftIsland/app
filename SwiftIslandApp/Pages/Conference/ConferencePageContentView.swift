//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import Defaults
import SwiftIslandDataLogic

struct ConferencePageContentView: View {
    var namespace: Namespace.ID

    @EnvironmentObject private var appDataModel: AppDataModel

    @Binding var isShowingMentor: Bool
    @Binding var mayShowMentorNextMentor: Bool
    @Binding var selectedMentor: Mentor?

    @State private var nextEvent: Event?

    @Default(.userIsActivated) private var userIsActivated

    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                ConferenceHeaderView()
                ConferenceBoxTicket()
                    .padding(.vertical, 6)

                VStack(alignment: .leading) {
                    Text("Mentors this year".uppercased())
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 40)
                        .padding(.top, 6)
                        .padding(.bottom, 0)
                    TabView {
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
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(minHeight: geo.size.width * 0.80)
                }

                if let nextEvent {
                    ConferenceBoxEvent(event: nextEvent)
                } else {
                    ProgressView()
                }

                // Removed for now.
//                        ConferenceBoxFAQ()
//                            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
//                            .scrollContentBackground(.hidden)
            }
            .onAppear {
                Task {
                    self.nextEvent = await appDataModel.nextEvent()
                }
            }
        }
    }
}
