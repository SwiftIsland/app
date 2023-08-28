//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import Defaults
import SwiftIslandDataLogic

extension Defaults.Keys {
    static let puzzleStatus = Key<[String: PuzzleState]>("puzzleStatus", default: [:])
    static let puzzleHints = Key<[String: String]>("puzzleHints", default: [:])
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


struct PuzzleGrid: View {
    @EnvironmentObject private var appDataModel: AppDataModel
    @State var currentPuzzleSlug: String?
    private let spacing: CGFloat = 0
    private let columns = Array(repeatElement(GridItem(.flexible(minimum: 44), spacing: 0), count: 4))
    var body: some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(appDataModel.puzzles) { puzzle in
                NavigationLink(value: puzzle, label: {
                    PuzzleItemView(puzzle: puzzle, isCurrent: (puzzle.slug == currentPuzzleSlug))
                }).disabled(puzzle.state == .NotFound)
            }
        }
        .padding(20)
        .navigationTitle("Spot the Seal")
        .navigationBarItems(trailing: Button("Reset", action: { Defaults.reset(.puzzleStatus) }))
        .navigationDestination(for: Puzzle.self) { puzzle in
            PuzzleView(puzzle: puzzle)
        }
    }
}

struct PuzzlePageView: View {
    @EnvironmentObject private var appDataModel: AppDataModel
    @Default(.puzzleStatus) var puzzleStatus
    @Default(.puzzleHints) var puzzleHints
    @State var currentPuzzleSlug: String?
    var body: some View {
        VStack {
            if (appDataModel.puzzles.count == 0) {
                Text("Loading...")
            } else {
                PuzzleGrid(currentPuzzleSlug: currentPuzzleSlug)
                Text("Hints").font(.title)
                ForEach(puzzleHints.keys.sorted(), id: \.self) { slug in
                    if let hint = puzzleHints[slug] {
                        let _ = print(hint, slug, puzzleStatus[slug])
                        let status = puzzleStatus[slug]
                        Text(hint).strikethrough(status != nil && status != .NotFound)
                    }
                }
            }
        }
        .task {
            await appDataModel.fetchPuzzles()
        }
        
    }
}

struct PuzzlePageView_Previews: PreviewProvider {
    static var previews: some View {
        let appDataModel = AppDataModel()
        PuzzlePageView().environmentObject(appDataModel)
    }
}

// Flow:
// Tap NFC: get a yellow stamp
// Open puzzle view, with other user nearby: highlight shared stamps by pulsating
// Tap pulsating stamp: flip and make orange
// Tap orange stamp: open puzzle
// Find solution to puzzle: make stamp red (and still flipped)
// Every solved puzzle has a hint, that is shown below the puzzle page
