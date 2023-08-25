//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import PDFKit
import Defaults

struct PDFViewUI : UIViewRepresentable {
    let pdfView = PDFView()
    var url: URL?
    init(url : URL) {
        self.url = url
        self.pdfView.backgroundColor = UIColor(white: 0.9, alpha: 1)

        self.pdfView.pageShadowsEnabled = false
        self.pdfView.pageBreakMargins = UIEdgeInsets()

    }
    
    func makeUIView(context: Context) -> UIView {
        if let url = url {
            pdfView.document = PDFDocument(url: url)
        }
//        pdfView.scaleFactor = 1.2
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Empty
    }
    
}
struct PuzzleView: View {
    @State var puzzle: Puzzle
    @State var solution: String = ""
    var body: some View {
        
        VStack(alignment: .center) {
            let url = Bundle.main.url(forResource: "1", withExtension: "pdf")
            if let url = url {
                ZStack {
                    PDFViewUI(url: url)        
                        .padding(1)
                    Image("frame")
                        .resizable(capInsets: EdgeInsets(),resizingMode: .stretch)
                        .allowsHitTesting(false)
                        .colorInvert()                        
                    }
                .aspectRatio(1, contentMode: .fit)
            } 
            Text(puzzle.description)
            Spacer()
            HStack(spacing: 20) {
                TextField("Solution", text:$solution)
                Button("Check") {
                    print("Text", solution)
                    if (solution == "\(puzzle.id)") {
                        print("Correct")
                        puzzle.state = .Solved
                    } else {
                        print("Wrong16")
                        solution = ""
                    }
                }
            }
        }.padding(20)
            .navigationTitle(puzzle.title)
     
    }
}

struct PuzzleView_Previews: PreviewProvider {
    @State static var puzzle = Puzzle(id: "16")
    static var previews: some View {
        PuzzleView( puzzle: $puzzle.wrappedValue)
    }
}
