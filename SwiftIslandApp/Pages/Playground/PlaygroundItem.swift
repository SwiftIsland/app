//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct PlaygroundItem<Content>: View where Content : View {
    let title: String
    let content: () -> Content
    var body: some View {
        NavigationLink(destination: content().navigationTitle(title)) { Text(title) }
    }
    
    init(title: String, @ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
        self.title = title
    }
}
