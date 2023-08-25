//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import Defaults

extension Defaults.Keys {
    static let puzzleStatus = Key<[String: PuzzleState]>("puzzleStatus", default: [:])
}

enum PuzzleState: String, Defaults.Serializable {
    case NotFound = "Not Found"
    case Found = "Found"
    case Nearby = "Nearby"
    case Activated = "Activated"
    case Solved = "Solved"
    
    var next: PuzzleState {
        switch(self) {
        case .NotFound: return .Found
        case .Found: return .Nearby
        case .Nearby: return .Activated
        case .Activated: return .Solved
        case .Solved: return .NotFound
        }
    }
}

struct Puzzle: Identifiable, Hashable {
    let id: String
    var title: String {
        return "Puzzle \(id)"
    }
    let description: String = "Puzzle description\nWith a really long name and some more text\nthat wont fit in one go"
    var state: PuzzleState {
        get {
            Defaults[.puzzleStatus][id] ?? .NotFound
        }
        set(newValue) {
            Defaults[.puzzleStatus][id] = newValue
        }
    }
    var color: Color {
        switch (state) {
        case .NotFound: return .clear
        case .Found, .Nearby: return .yellow
        case .Activated: return .orange
        case .Solved: return .red
        }
    }
}

let spacing: CGFloat = 0

struct PuzzlePageView: View {
    @Default(.puzzleStatus) var puzzleStatus
    @State var items: [Puzzle] = (1...16).map({Puzzle(id: "\($0)")})
    let columns = Array(repeatElement(GridItem(.flexible(minimum: 44), spacing: 0), count: 4))
    var body: some View {
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach($items) { puzzle in
                    NavigationLink(value: puzzle.wrappedValue, label: {
                        PuzzleItemView(puzzle: puzzle.wrappedValue) 
                    })
                }
            }.padding(20)
            .navigationTitle("Spot the Seal")
            .navigationBarItems(trailing: Button("Reset", action: { Defaults.reset(.puzzleStatus) }))
            Text("Hints").font(.title)
    }
}

struct PuzzlePageView_Previews: PreviewProvider {
    static var previews: some View {
        PuzzlePageView()
    }
}

// Flow:
// Tap NFC: get a yellow stamp
// Open puzzle view, with other user nearby: highlight shared stamps by pulsating
// Tap pulsating stamp: flip and make orange
// Tap orange stamp: open puzzle
// Find solution to puzzle: make stamp red (and still flipped)
// Every solved puzzle has a hint, that is shown below the puzzle page
