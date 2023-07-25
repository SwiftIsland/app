//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ScheduleView: View {

    @EnvironmentObject private var appDataModel: AppDataModel

    @State private var hourSpacing = 24.0
    @State private var hourHeight = 25.0
    @State private var selectedDate = Date()

    private let hours: [String] = {
        let df = DateFormatter()
        df.dateFormat = Locale.is24Hour ? "HH:mm" : "h a"

        var hours: [String] = []

        for hour in 0...24 {
            let date = Date().atHour(hour)!
            hours.append(df.string(from: date))
        }

        return hours
    }()

    var body: some View {
        ScrollView {
            ZStack {
                ScheduleCalendarView(hours: hours, hourSpacing: $hourSpacing, hourHeight: $hourHeight)

                let calendar = Calendar.current
                if calendar.isDateInToday(selectedDate) {
                    ScheduleTimelineView(hourSpacing: $hourSpacing, hourHeight: $hourHeight)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 62)
            }
            .navigationTitle("Event Schedule")
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        let appDataModel = AppDataModel()

        return NavigationStack {
            ScheduleView()
                .environmentObject(appDataModel)
        }
    }
}

private extension Locale {
    static var is24Hour: Bool {
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
        return dateFormat.firstIndex(of: "a") != nil
    }
}
