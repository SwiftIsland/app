//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI


struct PlaygroundPageView: View {
    var body: some View {
        PuzzlePageView()
//        NavigationStack {
//            List {
//                PlaygroundItem(title: "Puzzle Hunt", { PuzzlePageView() })
//            }.navigationTitle("Playground")
//        }
    }
}

struct PlaygroundPageView_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundPageView()
    }
}
