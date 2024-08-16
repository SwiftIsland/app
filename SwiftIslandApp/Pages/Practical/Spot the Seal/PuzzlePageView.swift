//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import Defaults
import SwiftIslandDataLogic

extension Defaults.Keys {
    static let puzzleStatus = Key<[String: PuzzleState]>("puzzleStatus", default: [:])
    static let puzzleHints = Key<[String: Hint]>("puzzleHints", default: [:])
}

enum PuzzleState: String, Defaults.Serializable {
    case notFound = "Not Found"
    case found = "Found"
    case nearby = "Nearby"
    case activated = "Activated"
    case solved = "Solved"
    
    var next: PuzzleState {
        switch self {
            // Not all states are currently used, they were part of an more elaborate flow we had in mind initially. Currently we only use .NotFound, .Found and .Solved
        case .notFound: return .found
        case .found: return .nearby
        case .nearby: return .activated
        case .activated: return .solved
        case .solved: return .notFound
        }
    }
}

extension Puzzle {
    var state: PuzzleState {
        get {
            Defaults[.puzzleStatus][slug] ?? .notFound
        }
        set(newValue) {
            Defaults[.puzzleStatus][slug] = newValue
        }
    }
    var color: Color {
        switch state {
        case .notFound: return .clear
        case .found, .nearby: return .questionMarkColor
        case .activated: return .yellowDark
        case .solved: return .green
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
                PuzzleItemView(puzzle: puzzle, isCurrent: (puzzle.slug == currentPuzzleSlug))
            }
        }
    }
}

struct PuzzlePageView: View {
    @EnvironmentObject private var appDataModel: AppDataModel
    
    @Default(.puzzleStatus)
    var puzzleStatus
    @Default(.puzzleHints)
    var puzzleHints
    
    @State var currentPuzzleSlug: String?
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if appDataModel.puzzles.isEmpty {
                    Text("Loading...")
                } else {
                    Text("Search for seals all across the conference grounds to find the 16 clues to solve this puzzle!")
                    Spacer()
                    Text("Puzzle").font(.title)
                    Text("Ten attendees of Swift Island met another person while on their way to the conference. Together they planned a trip on one of the conference days.\n\nWho met who and where did they meet?\nWhat trip did they plan together on which day?")
                    Spacer()
                    Text("Clues").font(.title)
                    VStack(alignment: .leading) {
                        ForEach(puzzleHints.keys.sorted(by: { slug1, slug2 in
                            guard let hint1 = puzzleHints[slug1], let hint2 = puzzleHints[slug2] else {
                                return false
                            }
                            return hint1.number < hint2.number
                        }), id: \.self) { slug in
                            if let hint = puzzleHints[slug] {
                                Text(hint.description).strikethrough(hint.used).onTapGesture {
                                    puzzleHints[slug]?.toggleUsed()
                                }
                                Spacer()
                            }
                        }
                    }
                    Spacer()
                    PuzzleGrid(currentPuzzleSlug: currentPuzzleSlug)
                }
            }
            .padding(20)
            .task {
                await appDataModel.fetchPuzzles()
            }
        }.navigationTitle("Spot the Seal")
    }
}


struct PuzzlePageView_Previews: PreviewProvider {
    static var previews: some View {
        let appDataModel = AppDataModel()
        PuzzlePageView().environmentObject(appDataModel)
    }
}
