//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ConferencePageView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.conferenceBackgroundFrom, .conferenceBackgroundTo], startPoint: UnitPoint(x: 0, y: 0.1), endPoint: UnitPoint(x: 1, y: 1))
                    .ignoresSafeArea()

                GeometryReader { geo in
                    ScrollView(.vertical) {
                        ConferenceHeaderView()
                        ConferenceBoxTicket()
                            .padding(.vertical, 6)

                        VStack(alignment: .leading) {
                            Text("Mentors this year".uppercased())
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 40)
                                .padding(.top, 6)
                                .padding(.bottom, 0)
                            ConferenceBoxMentors()
                                .frame(height: geo.size.width * 0.50)
                                .padding(.vertical, 0)
                        }

                        ConferenceBoxFAQ(faqList: [
                            FAQItem(id: "1", question: "Are there different kind of rooms?", answer: "Yes. The venue has bungalows and regular hotel rooms. Bungalows have 3 bedrooms, are more spacious, and have a shared kitchen and living room, while the Hotel Rooms have a private bathrooms. With your ticket you always get a private bedroom and you buy a ticket you can specify a preferred room type. While we try to accommodate everyone towards their preference, we can't guarantee you the room-type of your choice."),
                            FAQItem(id: "2", question: "Are these images actually from the island?", answer: "Yes! All photographs used on this site were shot on Texel. Some of them are shot by our attendees from 2018."),
                            FAQItem(id: "3", question: "Is the content the same as WWDC?", answer: " No. While the topics will be inspired by what is announced at WWDC, there are no talks at Swift Island, only workshops. During those workshops you get hands-on experience with these topics. So even if you are lucky enough to go to WWDC, Swift Island will be a great way to dive in deeper. Having been to WWDC is not at all a requirement, though. We expect the attendees to have some basic knowledge of what is announced, but we will quickly get you up to speed if you did not find the time to look into it yet. "),
                            FAQItem(id: "4", question: "Can I specify who I want to share a bungalow with?", answer: "Sure! Once you both have booked a ticket, please send us an email and we will make sure you will be placed in a bungalow together."),
                        ])
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
        }
    }
}

struct ConferencePageView_Previews: PreviewProvider {
    static var previews: some View {
        ConferencePageView()
    }
}
