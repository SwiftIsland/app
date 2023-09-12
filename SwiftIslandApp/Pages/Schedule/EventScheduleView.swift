//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SimpleCalendar
import SwiftIslandDataLogic

struct EventScheduleView: View {
    @EnvironmentObject private var appDataModel: AppDataModel
    @State private var events: [any CalendarEventRepresentable] = []
    @State private var selectedDate = Date()

    private var selectableDates: [Date] = {
        let calendar = Calendar.current

        return [
            calendar.date(from: DateComponents(year: 2023, month: 9, day: 4)),
            calendar.date(from: DateComponents(year: 2023, month: 9, day: 5)),
            calendar.date(from: DateComponents(year: 2023, month: 9, day: 6)),
            calendar.date(from: DateComponents(year: 2023, month: 9, day: 7))
        ].compactMap { $0 }
    }()

    var body: some View {
        SimpleCalendarView(events: $events, selectedDate: $selectedDate, dateSelectionStyle: .selectedDates(selectableDates))
            .navigationTitle("Event Schedule")
            .onAppear {
                let calendar = Calendar.current
                if let currentDate = self.selectableDates.first(where: { calendar.isDateInToday($0) }) {
                    selectedDate = currentDate
                } else {
                    selectedDate = selectableDates[0]
                }

                updateContent()
            }
    }

    private func updateContent() {
        self.events = appDataModel.events
    }
}

#Preview {
    EventScheduleView()
}

extension Activity: CalendarActivityRepresentable {
    public var activityType: SimpleCalendar.ActivityType {
        ActivityType(name: self.type.rawValue, color: self.type.color)
    }
}

extension Event: CalendarEventRepresentable {
    public var calendarActivity: SimpleCalendar.CalendarActivityRepresentable {
        activity
    }
}
