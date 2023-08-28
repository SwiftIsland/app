//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import Defaults
import SwiftIslandDataLogic

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

extension Puzzle {
    var state: PuzzleState {
        get {
            Defaults[.puzzleStatus][slug] ?? .NotFound
        }
        set(newValue) {
            Defaults[.puzzleStatus][slug] = newValue
        }
    }
    var color: Color {
        switch (state) {
        case .NotFound: return .clear
        case .Found, .Nearby: return .ticketText
        case .Activated: return .yellowDark
        case .Solved: return .questionMarkColor
        }
    }
}

let spacing: CGFloat = 0

struct PuzzlePageView: View {
    @EnvironmentObject private var appDataModel: AppDataModel
    @Default(.puzzleStatus) var puzzleStatus
    @State var items: [Puzzle] = []
    @State var currentPuzzleSlug: String?
    let columns = Array(repeatElement(GridItem(.flexible(minimum: 44), spacing: 0), count: 4))
    var body: some View {
        VStack {
            if (items.count == 0) {
                Text("Loading...")
            } else {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(appDataModel.puzzles) { puzzle in
                        NavigationLink(value: puzzle, label: {
                            PuzzleItemView(puzzle: puzzle, isCurrent: (puzzle.slug == currentPuzzleSlug))
                        }).isDetailLink(false)
                    }
                }
                .padding(20)
                .navigationTitle("Spot the Seal")
                .navigationBarItems(trailing: Button("Reset", action: { Defaults.reset(.puzzleStatus) }))
                .navigationDestination(for: Puzzle.self) { puzzle in
                    PuzzleView(puzzle: puzzle)
                }
                Text("Hints").font(.title)
                // TODO add all hints here
            }
        }
        .task {
            await appDataModel.fetchPuzzles()
        }
        
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
