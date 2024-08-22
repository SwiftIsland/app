//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct NavigationDestinationExample: View {
    private let mentor: Mentor = Mentor.forPreview()

    var body: some View {
        VStack {
            NavigationStack {
                List {
                    NavigationLink(value: mentor) {
                        HStack {
                            Image(mentor.imageName)
                                .resizable()
                                .scaledToFill()
                                .border(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.1), width: 1)
                                .aspectRatio(1.5, contentMode: .fit)
                                .frame(maxHeight: 100)
                                .cornerRadius(15)
                            Text(mentor.name)
                                .font(.title)
                        }
                    }
                }
                .navigationDestination(for: Mentor.self) { mentor in
                    MentorPageView(mentor: mentor)
//                        .toolbarVisibility(.visible, for: .navigationBar)
                }
            }
        }
    }
}

#Preview {
    NavigationDestinationExample()
}
