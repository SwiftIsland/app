//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct PracticalGenericPageView: View {
    let page: Page

    var body: some View {
        ZStack {
            LinearGradient.defaultBackground

            List {
                Section {
                    if !page.imageName.isEmpty {
                        VStack {
                            Image(page.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .frame(minHeight: 110)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    let content = page.content.replacing("\\n", with: "\n")
                    Text(LocalizedStringKey(content))
                        .dynamicTypeSize(DynamicTypeSize.small ... DynamicTypeSize.large)
                        .tint(.questionMarkColor)
                }
            }
        }
        .navigationTitle(page.title)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PracticalGenericPageView_Previews: PreviewProvider {
    static var previews: some View {
        let pages: [Page] = [
            Page.forPreview(
                id: "schiphol",
                title: "At schiphol",
                imageName: "schiphol"
            )
        ]

        Group {
            ForEach(pages, id: \.self) { page in
                PracticalGenericPageView(page: page)
                    .preferredColorScheme(.light)
                    .previewDisplayName("\(page.title) Light")

                PracticalGenericPageView(page: page)
                    .preferredColorScheme(.dark)
                    .previewDisplayName("\(page.title) Dark")
            }
        }
    }
}
