//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ConferenceMentorsView: View {
    let mentors: [Mentor]
    let selectedMentor: Mentor?

    var body: some View {
        VStack {
            if let selectedMentor {
                Text("Selected mentor: \(selectedMentor.firstName)")
            }
            Text("Mentors: \(mentors.count)")
        }
    }
}

struct ConferenceMentorsView_Previews: PreviewProvider {
    static var previews: some View {
        let mentors = [
            Mentor(userId: "1", firstName: "John", lastName: "Appleseed", userType: .mentor, headerImageUrl: nil)
        ]

        ConferenceMentorsView(mentors: mentors, selectedMentor: nil)
    }
}
