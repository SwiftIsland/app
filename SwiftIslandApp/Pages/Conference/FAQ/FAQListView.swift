//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct FAQListView: View {
    @State var faqList: [FAQItem] = []
    @State private var searchText = ""
    @State private var isSearching = false

    var preselectedItem: FAQItem?

    private let dataLogic = SwiftIslandDataLogic()

    private var filter: [FAQItem] {
        if !searchText.isEmpty {
            return faqList.filter { faqItem in
                faqItem.question.localizedCaseInsensitiveContains(searchText) ||
                faqItem.answer.localizedCaseInsensitiveContains(searchText)
            }
        } else {
            return faqList
        }
    }

    var body: some View {
        ScrollViewReader { scrollViewProxy in
            List {
                Section(header: Text("FAQ")) {
                    ForEach(filter) { faqItem in
                        ConferenceBoxFAQItem(faqItem: faqItem, short: false)
                    }
                }
            }
            .navigationTitle("FAQ")
            .listRowBackground(Color.clear)
            .onChange(of: searchText) { _, _ in
                isSearching = !searchText.isEmpty
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search") {
                ForEach(filter) { faqItem in
                    Text("\(faqItem.question)")
                        .searchCompletion("\(faqItem.question)")
                }
            }
            .task {
                if !isPreview {
                    let faqs: [FAQItem] = await dataLogic.fetchFAQItems()
                    self.faqList = Array(faqs.prefix(upTo: 4))

                    if let preselectedItem {
                        scrollViewProxy.scrollTo(preselectedItem.id)
                    }
                }
            }
        }
    }
}

struct FAQListView_Previews: PreviewProvider {
    static var previews: some View {
        let faqList = [
            FAQItem.forPreview(
                id: "1",
                question: "Are there different kind of rooms?",
                answer: "Yes. The venue has bungalows and regular hotel rooms. Bungalows have 3 bedrooms, are more spacious, and have a shared kitchen and "
            ),
            FAQItem.forPreview(
                id: "2",
                question: "Are these images actually from the island?",
                answer: "Yes! All photographs used on this site were shot on Texel. Some of them are shot by our attendees from 2018."
            ),
            FAQItem.forPreview(
                id: "3",
                question: "Is the content the same as WWDC?",
                answer: "No. While the topics will be inspired by what is announced at WWDC, there are no talks at Swift Island, only workshops. During those "
            ),
            FAQItem.forPreview(
                id: "4",
                question: "Can I specify who I want to share a bungalow with?",
                answer: "Sure! Once you both have booked a ticket, please send us an email and we will make sure you will be placed in a bungalow together."
            )
        ]

        NavigationStack {
            FAQListView(faqList: faqList)
        }
    }
}
