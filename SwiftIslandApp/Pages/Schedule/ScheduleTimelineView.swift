//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ScheduleTimelineView: View {
    @Binding var hourSpacing: Double
    @Binding var hourHeight: Double
    @State private var timelineOffset: Double = 0

    // Timer for updating the position of the timeline
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { _ in
            VStack {
                Divider()
                    .frame(height: 1)
                    .overlay(Color.redLight)
                    .offset(CGSize(width: 0, height: timelineOffset))
                    .padding(.vertical, 8)
            }
            .padding(.horizontal, 16)
            .onAppear {
                calculateOffset()
            }
        }
        .onReceive(timer) { _ in
            calculateOffset()
        }
    }

    func calculateOffset() {
        let actualHourHeight = hourHeight + hourSpacing
        let heightPerSecond = (actualHourHeight / 60) / 60
        let secondsSinceStartOfDay = abs(Date().atHour(6)?.timeIntervalSinceNow ?? 0)
        timelineOffset = secondsSinceStartOfDay * heightPerSecond
    }
}

struct ScheduleTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                ZStack {
                    ScheduleTimelineView(
                        hourSpacing: .constant(24),
                        hourHeight: .constant(30)
                    )
                }
                .frame(height: 580)
                Spacer()
                Text("End of view")
            }
        }
    }
}
