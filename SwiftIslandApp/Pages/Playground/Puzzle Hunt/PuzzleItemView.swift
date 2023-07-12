//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

let puzzleItemSize: CGFloat = 44
struct PuzzleItemView: View {
    let puzzle: Puzzle
    var body: some View {
        Text("\(puzzle.id)")
            .font(.custom("WorkSans-Bold", size: 20))
            .frame(width: puzzleItemSize, height: puzzleItemSize)
//            .padding(10)
            .background(
                Circle().stroke(style: StrokeStyle(lineWidth: 2)))
            .foregroundColor(puzzle.enabled ? .questionMarkColor : .black)
            .aspectRatio(1, contentMode: .fit)
            
    }
}

struct PuzzleItemView_Previews: PreviewProvider {
    static var previews: some View {
        Grid {
            PuzzleItemView(puzzle: Puzzle(id: 1, enabled: true))
            PuzzleItemView(puzzle: Puzzle(id: 15, enabled: false))
        }
    }
}
