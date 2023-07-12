//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct Puzzle: Identifiable, Hashable {
    let id: Int
    // FIXME: This should be based on NFC tags scanned instead of random
    var enabled: Bool = [true,false].randomElement() ?? false
}

struct PuzzlePageView: View {
    @State var items: [Puzzle] = (1...20).map({Puzzle(id: $0)})
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        NavigationStack {
            LazyVGrid(columns: columns, spacing: 20) {
                    ForEach($items) { puzzle in
                        if (puzzle.enabled.wrappedValue) {
                            NavigationLink(destination: {
                                PuzzleView(puzzle: puzzle)
                            }, label: {
                                Text("\(puzzle.id)")
                            })
                        } else {
                            Text("\(puzzle.id)")
                        }
                    }
            }.navigationTitle("Puzzle Hunt")
        }
    }
}

struct PuzzlePageView_Previews: PreviewProvider {
    static var previews: some View {
        PuzzlePageView()
    }
}
