//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ConferenceBoxFAQItem: View {
    let faqItem: FAQItem
    let short: Bool

    var body: some View {
        HStack {
            Image(systemName: "questionmark.circle")
                .font(.title)
                .fontWeight(.light)
                .foregroundColor(.questionMarkColor)
            VStack(alignment: .leading) {
                Text(faqItem.question)
                    .font(.body)
                    .fontWeight(.semibold)
                Text(faqItem.answer)
                    .font(.callout)
                    .fontWeight(.regular)
                    .foregroundColor(.secondary)
                    .lineLimit(short ? 3 : 9999)
                    .padding(.vertical, 1)
            }
        }
    }
}

struct ConferenceBoxFAQItem_Previews: PreviewProvider {
    static var previews: some View {
        ConferenceBoxFAQItem(faqItem: FAQItem(id: "1", question: "Lorum ipsum", answer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec tortor orci, lobortis eget feugiat vel, condimentum eget urna. Duis luctus purus mi, et posuere diam viverra eget."), short: true)
    }
}
