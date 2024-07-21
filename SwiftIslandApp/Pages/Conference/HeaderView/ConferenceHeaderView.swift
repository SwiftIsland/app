//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ConferenceHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            RowView(title: "AUG 27-29/2024", image: "calendar.badge.plus")
            RowView(title: "TEXEL - Netherlands", image: "map.fill")
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ConferenceHeaderView()
}

private struct RowView: View {
    let title: String
    let image: String

    var body: some View {
        HStack(alignment: .center, spacing: 11) {
            Image(systemName: image)
            Text(title)
            Spacer()
        }
        .font(.body)
        .fontWeight(.semibold)
    }
}
