//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct ConferenceBoxEvent: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading) {
            Text("Next up".uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
                .padding(.top, 6)
                .padding(.bottom, 0)
            ZStack {
                Color.secondarySystemGroupedBackground
                VStack(alignment: .leading, spacing: 0) {
                    if event.startDate.timeIntervalSinceNow > ((24 * 60) * 7) {
                        Text("Sure, _early bird gets the worm_, but you are a little too early just yet 😉\n\nCheck back here a few days before the event.")
                            .font(.footnote)
                            .fontWeight(.light)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        Text(event.activity.type.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fontWeight(.light)
                        HStack {
                            Circle()
                                .fill(event.activity.type.color)
                                .frame(width: 7)
                            Text(event.activity.title)
                                .font(.title)
                        }
                        .padding(.bottom, 8)
                        HStack {
                            Text(event.startDate.formatted())
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(event.startDate.relativeDateDisplay())
                                .font(.caption)
                        }
                    }
                }
                .padding()
            }
            .mask {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }
}

struct ConferenceNextEvent_Previews: PreviewProvider {
    static var previews: some View {
        ConferenceBoxEvent(event: Event.forPreview())
    }
}
