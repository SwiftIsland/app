//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct MentorImage: View {
    var namespace: Namespace.ID
    let mentor: Mentor

    var body: some View {
        Color.clear
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                Image(mentor.imageName)
                    .resizable()
                    .scaledToFill()
                    .matchedGeometryEffect(id: "\(mentor.id)-imageName", in: namespace)
            )
            .clipShape(Rectangle())
    }
}

#Preview {
    @Namespace var namespace
    let mentor = Mentor.forPreview()

    return MentorImage(namespace: namespace, mentor: mentor)
}
