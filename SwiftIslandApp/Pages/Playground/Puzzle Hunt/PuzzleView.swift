//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct PuzzleView: View {
    @Binding var puzzle: Puzzle
    @State var solution: String = ""
    var body: some View {
        VStack(alignment: .center) {
            Image("BoxTicketBackground")
            Text("Puzzle \(puzzle.id)")
            HStack(spacing: 20) {
                TextField("Solution", text:$solution)
                Button("Submit") {
                    print("Text", solution)
                    if (solution == "\(puzzle.id)") {
                        print("Correct")
                    } else {
                        print("Wrong16")
                        solution = ""
                    }
                }
            }
        }.padding(20)
    }
}

struct PuzzleView_Previews: PreviewProvider {
    @State static var puzzle = Puzzle(id: 16)
    static var previews: some View {
        PuzzleView(puzzle: $puzzle)
    }
}
