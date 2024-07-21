//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct MentorBoxView: View {
    var namespace: Namespace.ID
    let mentor: Mentor

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            MentorImage(namespace: namespace, mentor: mentor)
            VStack(alignment: .leading) {
                let splitName = mentor.name.components(separatedBy: " ")
                ForEach(splitName, id:\.self) { namePart in
                    Text(namePart)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .foregroundStyle(.pink)
                        .background(.white)
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                }
            }
            .matchedGeometryEffect(id: "\(mentor.id)-mentorExcerptView", in: namespace)
            .frame(maxWidth: .infinity, alignment: .bottomLeading)
            .padding(.bottom, 18)
            .padding(.leading, 20)
        }
    }
}

#Preview("No content") {
    @Namespace var namespace
    let mentor = Mentor.forPreview()

    return MentorBoxView(namespace: namespace, mentor: mentor)
}

#Preview("Showing content") {
    @Namespace var namespace
    let mentor = Mentor.forPreview()

    return MentorBoxView(namespace: namespace, mentor: mentor)
}
