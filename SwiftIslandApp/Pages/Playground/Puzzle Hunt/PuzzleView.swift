//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct PuzzleView: View {
    @Binding var puzzle: Puzzle
    var body: some View {
        Text("Puzzle \(puzzle.id)")
    }
}

struct PuzzleView_Previews: PreviewProvider {
    @State static var puzzle = Puzzle(id: 16)
    static var previews: some View {
        PuzzleView(puzzle: $puzzle)
    }
}
