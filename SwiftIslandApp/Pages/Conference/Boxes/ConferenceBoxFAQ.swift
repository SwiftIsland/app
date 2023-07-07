//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct FAQItem: Codable, Hashable, Identifiable {
    var id: String
    var question: String
    var answer: String
}

struct ConferenceBoxFAQ: View {
    @State var faqList: [FAQItem] = []

    var body: some View {
        List {
            Section(header: Text("FAQ")) {
                ForEach(faqList) { faqItem in
                    NavigationLink(value: faqItem) {
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
                                    .lineLimit(3)
                                    .padding(.vertical, 1)
                            }
                        }
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
    }
}

struct ConferenceBoxFAQ_Previews: PreviewProvider {
    static var previews: some View {
        let faqList = [
            FAQItem(id: "1", question: "Are there different kind of rooms?", answer: "Yes. The venue has bungalows and regular hotel rooms. Bungalows have 3 bedrooms, are more spacious, and have a shared kitchen and living room, while the Hotel Rooms have a private bathrooms. With your ticket you always get a private bedroom and you buy a ticket you can specify a preferred room type. While we try to accommodate everyone towards their preference, we can't guarantee you the room-type of your choice."),
            FAQItem(id: "2", question: "Are these images actually from the island?", answer: "Yes! All photographs used on this site were shot on Texel. Some of them are shot by our attendees from 2018."),
            FAQItem(id: "3", question: "Is the content the same as WWDC?", answer: "No. While the topics will be inspired by what is announced at WWDC, there are no talks at Swift Island, only workshops. During those workshops you get hands-on experience with these topics. So even if you are lucky enough to go to WWDC, Swift Island will be a great way to dive in deeper. Having been to WWDC is not at all a requirement, though. We expect the attendees to have some basic knowledge of what is announced, but we will quickly get you up to speed if you did not find the time to look into it yet. "),
            FAQItem(id: "4", question: "Can I specify who I want to share a bungalow with?", answer: "Sure! Once you both have booked a ticket, please send us an email and we will make sure you will be placed in a bungalow together."),
        ]

        NavigationStack {
            ConferenceBoxFAQ(faqList: faqList)
        }
    }
}
