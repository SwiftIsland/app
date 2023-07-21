//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct PracticalGenericPageView: View {
    let page: Page

    var body: some View {
        ZStack {
            LinearGradient.defaultBackground

            List {
                Section {

                }
            }
        }
    }
}

struct PracticalGenericPageView_Previews: PreviewProvider {
    static var previews: some View {
        PracticalGenericPageView(page: Page.forPreview())
    }
}
