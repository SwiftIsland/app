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

    @Default(.userIsActivated)
    private var userIsActivated

    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                if !userIsActivated {
                    ConferenceHeaderView()
                    ConferenceBoxTicket()
                        .padding(.vertical, 6)

                    ConferenceBoxMentors(
                        namespace: namespace,
                        geo: geo,
                        isShowingMentor: $isShowingMentor,
                        mayShowMentorNextMentor: $mayShowMentorNextMentor,
                        selectedMentor: $selectedMentor)

                    if let nextEvent {
                        ConferenceBoxEvent(event: nextEvent)
                    } else {
                        ProgressView()
                    }
                } else {
                    ConferenceHeaderView()

                    if let nextEvent {
                        ConferenceBoxEvent(event: nextEvent)
                    } else {
                        ProgressView()
                    }

                    ConferenceBoxMentors(
                        namespace: namespace,
                        geo: geo,
                        isShowingMentor: $isShowingMentor,
                        mayShowMentorNextMentor: $mayShowMentorNextMentor,
                        selectedMentor: $selectedMentor)
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
