//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ScheduleView: View {

    @State private var hourSpacing = 24.0
    @State private var hourHeight = 25.0

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
        NavigationStack {
            ScheduleView()
        }
    }
}

private extension Locale {
    static var is24Hour: Bool {
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
        return dateFormat.firstIndex(of: "a") != nil
    }
}

private extension Date {
    func atHour(_ hour: Int, minute: Int = 0, second: Int = 0) -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)

        components.hour = hour
        components.minute = minute
        components.second = second

        return calendar.date(from: components)
    }

    var hour: Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)

        return components.hour
    }
}
