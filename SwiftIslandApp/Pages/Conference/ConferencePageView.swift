//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct ConferencePageView: View {
    var namespace: Namespace.ID

    @Binding var selectedMentor: Mentor?
    @Binding var isShowingMentor: Bool

    @State private var mentors: [Mentor] = []

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.conferenceBackgroundFrom, .conferenceBackgroundTo], startPoint: UnitPoint(x: 0, y: 0.1), endPoint: UnitPoint(x: 1, y: 1))
                    .ignoresSafeArea()

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
                                ForEach(mentors) { mentor in
                                    MentorView(namespace: namespace, mentor: mentor, isShowContent: $isShowingMentor)
                                        .matchedGeometryEffect(id: mentor.id, in: namespace)
                                        .mask {
                                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                        }
                                        .padding(.horizontal, 20)
                                        .onTapGesture {
                                            withAnimation(.interactiveSpring(response: 0.55, dampingFraction: 0.8)) {
                                                self.selectedMentor = mentor
                                                self.isShowingMentor.toggle()
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
            }
            .navigationDestination(for: [FAQItem].self) { _ in
                FAQListView()
            }
            .navigationDestination(for: FAQItem.self) { item in
                FAQListView(preselectedItem: item)
            }
            .onAppear {
                fetchMentors()
            }
        }
        .accentColor(.white)
    }

    private func fetchMentors() {
        Task {
            let request = FetchMentorsRequest()
            do {
                self.mentors = try await Firestore.get(request: request).sorted(by: { $0.order < $1.order })
            }
        }
    }
}

struct ConferencePageView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        ConferencePageView(namespace: namespace, selectedMentor: .constant(nil), isShowingMentor: .constant(false))
    }
}
