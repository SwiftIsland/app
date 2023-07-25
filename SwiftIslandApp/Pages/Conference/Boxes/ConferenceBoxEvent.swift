//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ConferenceBoxEvent: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading) {
            Text("Mentors this year".uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
                .padding(.top, 6)
                .padding(.bottom, 0)
            ZStack {
                Color.white
                VStack(alignment: .leading, spacing: 8) {
                    Text(event.activity.title)
                        .font(.title)
                    HStack {
                        Text(event.startDate.formatted())
                        Spacer()
                        Text(event.startDate.relativeDateDisplay())
                    }
                }
                .padding()
            }
            .mask {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
            }
            .padding()
            .frame(minHeight: 150)
        }
    }
}

struct ConferenceNextEvent_Previews: PreviewProvider {
    static var previews: some View {
        let dbEvent = DBEvent(id: "1", activityId: "1", startDate: Date().addingTimeInterval(60))
        let activity = Activity(id: "1",
                                title: "Lorum Ipsum",
                                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vestibulum maximus quam, eget egestas nisi accumsan eget. Phasellus egestas tristique tortor, vel interdum lorem porta non.",
                                mentors: [],
                                type: "foobar",
                                imageName: nil,
                                duration: 60*60)
        let event = Event(dbEvent: dbEvent, activity: activity)

        List {
            ConferenceBoxEvent(event: event)
        }
    }
}
