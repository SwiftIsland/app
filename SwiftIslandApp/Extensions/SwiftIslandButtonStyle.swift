//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct SwiftIslandButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color.questionMarkColor)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}

struct SwiftIslandButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Button("Button Title!") {
            }
            .preferredColorScheme(.light)
            .buttonStyle(SwiftIslandButtonStyle())
            .previewDisplayName("Light")

            Button("Button Title!") {
            }
            .preferredColorScheme(.dark)
            .buttonStyle(SwiftIslandButtonStyle())
            .previewDisplayName("Dark")
        }
    }
}
