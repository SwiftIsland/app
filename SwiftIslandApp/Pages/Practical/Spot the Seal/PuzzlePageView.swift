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
        // Not all states are currently used, they were part of an more elaborate flow we had in mind initially. Currently we only use .NotFound, .Found and .Solved
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
        case .Found, .Nearby: return .questionMarkColor
        case .Activated: return .yellowDark
        case .Solved: return .green
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
                VStack(alignment: .leading) {
                    Text("Put your phone against any seal you discover ").strikethrough(!puzzleStatus.isEmpty)
                    ForEach(puzzleHints.keys.sorted(), id: \.self) { slug in
                        if let hint = puzzleHints[slug] {
                            let status = puzzleStatus[slug]
                            let usedHint = status != nil && status != .NotFound
                            Text(hint).strikethrough(usedHint)
                        }
                    }
                }
            }
        }
        .task {
            await appDataModel.fetchPuzzles()
        }
        .navigationDestination(for: Puzzle.self) { puzzle in
            PuzzleView(puzzle: puzzle)
        }
        
    }
}

struct PuzzlePageView_Previews: PreviewProvider {
    static var previews: some View {
        let appDataModel = AppDataModel()
        PuzzlePageView().environmentObject(appDataModel)
    }
}

