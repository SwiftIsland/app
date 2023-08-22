//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct ConferencePageView: View {
    var namespace: Namespace.ID

    @EnvironmentObject private var appDataModel: AppDataModel

    @State private var selectedMentor: Mentor?
    @Binding var isShowingMentor: Bool
    @State private var mayShowMentorNextMentor: Bool = true

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.defaultBackground

                ConferencePageContentView(namespace: namespace,
                                          isShowingMentor: $isShowingMentor,
                                          mayShowMentorNextMentor: $mayShowMentorNextMentor,
                                          selectedMentor: $selectedMentor)

                // The Mentor view when a mentor is selected
                if let mentor = selectedMentor, isShowingMentor {
                    MentorView(namespace: namespace, mentor: mentor, isShowContent: $isShowingMentor)
                        .matchedGeometryEffect(id: mentor.id, in: namespace)
                        .ignoresSafeArea()
                        .onDisappear {
                            mayShowMentorNextMentor = true
                        }
                }
            }
            .navigationDestination(for: [FAQItem].self) { _ in
                FAQListView()
            }
            .navigationDestination(for: FAQItem.self) { item in
                FAQListView(preselectedItem: item)
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: UIDevice.current.hasNotch ? 88 : 66)
            }
        }
        .accentColor(.white)
    }
}

struct ConferencePageView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        let event = Event.forPreview()

        let appDataModel = AppDataModel(checkinListSlug: "")
        appDataModel.events = [event]

        return ConferencePageView(namespace: namespace, isShowingMentor: .constant(false))
            .environmentObject(appDataModel)
    }
}
