//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

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
                            .frame(height: geo.size.width * 0.50)
                        }

                        ConferenceBoxFAQ()
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                            .scrollContentBackground(.hidden)
                    }
                }

                if let mentor = selectedMentor, isShowingMentor {
                    MentorView(namespace: namespace, mentor: mentor, isShowContent: $isShowingMentor)
                        .matchedGeometryEffect(id: mentor.id, in: namespace)
                        .ignoresSafeArea()
                        .onDisappear {
                            mayShowMentorNextMentor = true
                            debugPrint("Done!")
                        }
                }
            }
            .navigationDestination(for: [FAQItem].self) { _ in
                FAQListView()
            }
            .navigationDestination(for: FAQItem.self) { item in
                FAQListView(preselectedItem: item)
            }
        }
        .accentColor(.white)
    }
}

struct ConferencePageView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        ConferencePageView(namespace: namespace, isShowingMentor: .constant(false))
    }
}
