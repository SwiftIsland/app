//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//

import SwiftUI

struct MatchedGeometryExample: View {
    @Namespace private var animationNamespace
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .center) {
            if isExpanded {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.blue)
                    .matchedGeometryEffect(id: "rectangle", in: animationNamespace)
                    .frame(width: 300, height: 300)
                    .onTapGesture {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }
            } else {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.red)
                    .matchedGeometryEffect(id: "rectangle", in: animationNamespace)
                    .frame(width: 100, height: 100)
                    .onTapGesture {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }
            }
        }
        .frame(width: 300, height: 300)
    }
}

#Preview {
    MatchedGeometryExample()
}

