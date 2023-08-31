//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import PDFKit
import Defaults
import SwiftIslandDataLogic

struct Hint: Decodable, Encodable {
    let text: String
    let forPuzzle: String
}

struct PDFViewUI: UIViewRepresentable {
    let pdfView = PDFView()
    var url: URL?
    init(url: URL, backgroundColor: Color = .gray) {
        self.url = url
        self.pdfView.backgroundColor = UIColor(backgroundColor)

        self.pdfView.pageShadowsEnabled = false
        self.pdfView.pageBreakMargins = UIEdgeInsets()
    }

    func makeUIView(context: Context) -> UIView {
        if let url = url {
            pdfView.document = PDFDocument(url: url)
        }
        pdfView.scaleFactor = 0.1
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Empty
    }
}

struct ShakeEffect: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: -30 * sin(position * 2 * .pi), y: 0))
    }

    init(shakes: Int) {
        position = CGFloat(shakes)
    }

    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
}

struct PuzzleView: View {
    @EnvironmentObject private var appDataModel: AppDataModel

    @Environment(\.colorScheme)
    private var colorScheme

    @Default(.puzzleStatus)
    private var puzzleStatus

    @State var puzzle: Puzzle
    @State var solution: String = ""
    @State var invalidAttempts = 0

    var body: some View {
        VStack(alignment: .center) {
            let url = Bundle.main.url(forResource: puzzle.filename, withExtension: "pdf")
            if let url = url {
                let frameColor: Color = colorScheme == .light ? .black : .white
                let pdfBackgroundColor = colorScheme == .light ? Color(white: 0.9) : Color(white: 0.1)
                ZStack {
                    PDFViewUI(url: url, backgroundColor: pdfBackgroundColor)
                    Image("frame")
                        .renderingMode(.template)
                        .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                        .foregroundColor(frameColor)
                        .allowsHitTesting(false)
                        .colorInvert()
                }
                .aspectRatio(1, contentMode: .fit)
            }
            if puzzle.state != .solved {
                Text("\(puzzle.question) (\(puzzle.answerLength))").font(.headline)
                if let tip = puzzle.tip {
                    Text(tip).font(.footnote)
                }
                HStack(spacing: 20) {
                    TextField("Solution", text: $solution)
                        .disableAutocorrection(true)
                        .modifier(ShakeEffect(shakes: invalidAttempts * 2))
                    Button("Check") {
                        do {
                            let hint = try decrypt(value: puzzle.encryptedHint, solution: solution, type: Hint.self)
                            if let forPuzzle = appDataModel.puzzles.first(where: { $0.number == hint.forPuzzle }) {
                                Defaults[.puzzleHints][forPuzzle.slug] = hint.text
                            }
                            withAnimation {
                                puzzle.state = .solved
                            }
                        } catch {
                            withAnimation(.linear) {
                                invalidAttempts += 1
                            }
                        }
                    }
                }
            } else {
                Image(systemName: "checkmark.seal")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.green)
                    .frame(width: 100)
            }
        }.padding(20)
            .navigationTitle(puzzle.title)
    }
}

struct PuzzleView_Previews: PreviewProvider {
    @State static var puzzle = Puzzle.forPreview(number: "16", filename: "marquee")
    static var previews: some View {
        PuzzleView( puzzle: $puzzle.wrappedValue).preferredColorScheme(.light)
        PuzzleView( puzzle: $puzzle.wrappedValue).preferredColorScheme(.dark)
    }
}
