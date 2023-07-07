//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ConferenceBoxMentors: View {
    @State private var mentors: [Mentor] = []

    var body: some View {
        VStack {
            if mentors.isEmpty {
                ProgressView()
                Text("Fetching mentors")
            } else {
                GeometryReader { geo in
                    TabView {
                        ForEach(mentors) { mentor in
                            ZStack {
                                Button(action: {
                                    debugPrint("Do something")
                                }, label: {
                                    ConferenceBoxMentorsMentor(mentor: mentor)
                                        .frame(maxWidth: geo.size.width - 40, alignment: .topLeading)
                                })
                            }
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
        }
        .onAppear {
            fetchMentors()
        }
    }

    private func fetchMentors() {
        Task {
            let request = AllMentorsRequest()
            do {
                let mentors = try await Firestore.get(request: request)
                self.mentors = mentors
            } catch {
                debugPrint("Could not fetch mentors. Error: \(error.localizedDescription)")
            }
        }
    }
}

struct ConferenceBoxMentors_Previews: PreviewProvider {
    static var previews: some View {


        ConferenceBoxMentors()
    }
}

