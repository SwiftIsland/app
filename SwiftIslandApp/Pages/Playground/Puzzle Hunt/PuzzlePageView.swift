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

let spacing: CGFloat = 20

struct PuzzlePageView: View {
    @State var items: [Puzzle] = (1...16).map({Puzzle(id: $0)})
    let columns = Array(repeatElement(GridItem(.fixed(puzzleItemSize), spacing: spacing), count: 4))
    var body: some View {
        NavigationStack {
            LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach($items) { puzzle in
                        if (puzzle.enabled.wrappedValue) {
                            NavigationLink(destination: {
                                PuzzleView(puzzle: puzzle)
                            }, label: {
                                PuzzleItemView(puzzle: puzzle.wrappedValue)
                            })
                        } else {
                            PuzzleItemView(puzzle: puzzle.wrappedValue)
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
