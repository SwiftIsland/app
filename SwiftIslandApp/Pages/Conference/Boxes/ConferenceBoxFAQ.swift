//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct ConferenceBoxFAQ: View {
    @State var faqList: [FAQItem] = []

    private let dataLogic = SwiftIslandDataLogic()

    var body: some View {
        List {
            Section(header: Text("FAQ")) {
                ForEach(faqList) { faqItem in
                    NavigationLink(value: faqItem) {
                        ConferenceBoxFAQItem(faqItem: faqItem, short: true)
                    }
                }
                NavigationLink(value: faqList) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("More")
                                .font(.body)
                                .fontWeight(.semibold)
                            Text("More answers can be found on the FAQ page")
                                .font(.callout)
                                .fontWeight(.regular)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .listRowBackground(Color.clear)
        .onAppear {
            fetchFAQ()
        }
    }

    private func fetchFAQ() {
        Task {
            self.faqList = await dataLogic.fetchFAQItems()
        }
    }
}

struct ConferenceBoxFAQ_Previews: PreviewProvider {
    static var previews: some View {
        let faqList = [
            FAQItem.forPreview(
                id: "1",
                question: "Are there different kind of rooms?",
                answer: "Yes. The venue has bungalows and regular hotel rooms. Bungalows have 3 bedrooms, are more spacious"
            ),
            FAQItem.forPreview(
                id: "2",
                question: "Are these images actually from the island?",
                answer: "Yes! All photographs used on this site were shot on Texel. Some of them are shot by our attendees from 2018."
            ),
            FAQItem.forPreview(
                id: "3",
                question: "Is the content the same as WWDC?",
                answer: "No. While the topics will be inspired by what is announced at WWDC, there are no talks at Swift Island, only workshops."
            ),
            FAQItem.forPreview(
                id: "4",
                question: "Can I specify who I want to share a bungalow with?",
                answer: "Sure! Once you both have booked a ticket, please send us an email and we will make sure you will be placed in a bungalow together."
            )
        ]

        NavigationStack {
            ConferenceBoxFAQ(faqList: faqList)
        }
    }
}
