//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

let sealAngle: Double = 24
let fromAngle: Double = -45 - sealAngle
let toAngle: Double = 45 - sealAngle

let puzzleItemSize: CGFloat = 88
class PuzzleItemViewModel: ObservableObject {
    @Published var angle = Angle(degrees: Double.random(in: fromAngle..<toAngle))
    @Published var x = CGFloat.random(in: -5...4)
    @Published var y = CGFloat.random(in: -5...4)
    @Published var puzzle: Puzzle
    @Published var scale: Double = 1
    @Published var flipAngle: CGFloat = 0
    @Published var isCurrent = false

    init(puzzle: Puzzle, isCurrent: Bool = false) {
        self.puzzle = puzzle
        self.isCurrent = isCurrent
        self.flipAngle = puzzle.state == .solved ? 180 : 0
    }
}

struct PuzzleItemView: View {
    @StateObject var viewModel: PuzzleItemViewModel

    @Environment(\.colorScheme)
    private var colorScheme

    init(puzzle: Puzzle, isCurrent: Bool = false) {
        _viewModel = StateObject(wrappedValue: PuzzleItemViewModel(puzzle: puzzle, isCurrent: isCurrent))
    }

    var body: some View {
        let color: Color = colorScheme == .light ? .black : .white
        let puzzle = viewModel.puzzle
        let stack = ZStack {
            Text("\(puzzle.number)")
                .font(.custom("WorkSans-Bold", size: 30))
            Rectangle().stroke(style: StrokeStyle(lineWidth: 2))
            Image("stamp")
                .renderingMode(.template)
                .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(puzzle.color)
                .rotationEffect(viewModel.angle, anchor: .center)
                .rotation3DEffect(
                    .degrees(viewModel.flipAngle),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    anchor: .center,
                    anchorZ: 0.0,
                    perspective: 1.0
                )
                .offset(x: viewModel.x, y: viewModel.y)
                .scaleEffect(viewModel.scale)
        }
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(color)
        switch puzzle.state {
        case .found:
            stack
                .onAppear {
                    if viewModel.isCurrent {
                        viewModel.scale = 50
                        withAnimation(.easeInOut(duration: 0.3).delay(0.1)) {
                            viewModel.scale = 1
                        }
                        Task {
                            try await Task.sleep(until: .now + .seconds(1.0), clock: .continuous)
                            viewModel.scale = 1
                            let baseAnimation = Animation.easeInOut(duration: 0.2)
                            let repeated = baseAnimation.repeatForever(autoreverses: true)
                            withAnimation(repeated) {
                                viewModel.scale = 1.07
                            }
                        }
                    }
                }
        case .solved, .notFound, .nearby, .activated:
            stack
        }
    }
}

struct PuzzleItemView_Previews: PreviewProvider {
    static var previews: some View {
        Grid {
            PuzzleItemView(puzzle: Puzzle.forPreview(number: "1"))
            PuzzleItemView(puzzle: Puzzle.forPreview(number: "15"))
        }.preferredColorScheme(.light)
        Grid {
            PuzzleItemView(puzzle: Puzzle.forPreview(number: "1"))
            PuzzleItemView(puzzle: Puzzle.forPreview(number: "15"))
        }.preferredColorScheme(.dark)
    }
}
