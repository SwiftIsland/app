//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct ScheduleView: View {
    private struct EventPositions {
        var id: String
        var sharePositionWith: [String] = []
        var position: CGRect
    }

    @EnvironmentObject private var appDataModel: AppDataModel

    @State private var hourSpacing = 24.0
    @State private var hourHeight = 25.0
    @State private var selectedDate: Date? = Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 26))
    @State private var showPopover = false
    @State private var selectedDayTag = 4
    @State private var events: [Event] = []

    private let startHourOfDay = 6
    private var hours: [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Locale.is24Hour ? "HH:mm" : "h a"

        var hours: [String] = []

        for hour in startHourOfDay...24 {
            if let date = Date().atHour(hour) {
                hours.append(dateFormatter.string(from: date))
            }
        }

        return hours
    }
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMdd")
        return dateFormatter
    }()
    private let leadingPadding = 70.0
    private let boxSpacing = 5.0

    @State private var foo: Event?

    var body: some View {
        ScrollView {
            ZStack {
                ScheduleCalendarView(hours: hours, hourSpacing: $hourSpacing, hourHeight: $hourHeight)

                let calendar = Calendar.current
                if let selectedDate, calendar.isDateInToday(selectedDate) {
                    ScheduleTimelineView(hourSpacing: $hourSpacing, hourHeight: $hourHeight)
                }

                GeometryReader { geo in
                    let width = (geo.size.width - leadingPadding)

                    ForEach(events) { event in
                        let boxWidth = (width / Double(event.columnCount + 1)) - boxSpacing
                        EventView(event: event)
                            .offset(CGSize(width: boxWidth * Double(event.column) + (boxSpacing * Double(event.column)), height: (event.coordinates?.minY ?? 0)))
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                            .frame(width: boxWidth, height: event.coordinates?.height ?? 20)
                    }
                    .padding(.top, 12)
                    .padding(.leading, leadingPadding)
                }
            }
            .navigationTitle("Event Schedule")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showPopover = true
                    } label: {
                        Text(selectedDate ?? Date(), formatter: dateFormatter)
                            .foregroundColor(.questionMarkColor)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(Color(UIColor.tertiarySystemGroupedBackground))
                            )
                            .popover(
                                isPresented: $showPopover,
                                attachmentAnchor: .point(.bottom),
                                arrowEdge: .top
                            ) {
                                VStack(alignment: .trailing) {
                                    Text("Select day")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Picker("Select conference day", selection: $selectedDayTag) {
                                        Text("Monday").tag(4) // 4th of September
                                        Text("Tuesday").tag(5)
                                        Text("Wednesday").tag(6)
                                        Text("Thursday").tag(7)
                                    }
                                    .pickerStyle(.segmented)
                                }
                                .padding()
                                .presentationCompactAdaptation(.popover)
                            }
                    }
                }
            }
        }
        .onChange(of: selectedDayTag) { _, _ in
            showPopover = false
            self.selectedDate = Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: selectedDayTag))
            updateContent()
        }
        .onAppear {
            let calendar = Calendar.current

            if let tuesday = calendar.date(from: DateComponents(year: 2024, month: 9, day: 5)), calendar.isDateInToday(tuesday) {
                selectedDate = tuesday
            } else if let wednesday = calendar.date(from: DateComponents(year: 2024, month: 9, day: 5)), calendar.isDateInToday(wednesday) {
                selectedDate = wednesday
            } else if let thursday = calendar.date(from: DateComponents(year: 2024, month: 9, day: 6)), calendar.isDateInToday(thursday) {
                selectedDate = thursday
            }

            updateContent()
        }
    }

    private func updateContent() {
        guard let date = selectedDate else { return }
        let allEvents = appDataModel.events

        let filteredEvents = allEvents.filter {
            return Calendar.current.isDate($0.startDate, inSameDayAs: date)
        }

        self.events = filteredEvents
        calculateCoordinates(forEvents: filteredEvents)
    }

    private func calculateCoordinates(forEvents events: [Event]) {
        var eventList: [Event] = []

        var pos: [EventPositions] = []

        let actualHourHeight = hourHeight + hourSpacing
        let heightPerSecond = (actualHourHeight / 60) / 60

        guard let selectedDate else { return }

        // Go over each event and check if there is another event ongoing at the same time
        events.forEach { event in
            let activity = event.activity
            var event = event

            let secondsSinceStartOfDay = abs(selectedDate.atHour(startHourOfDay)?.timeIntervalSince(event.startDate) ?? 0)

            let frame = CGRect(x: 0, y: secondsSinceStartOfDay * heightPerSecond, width: 60, height: activity.duration * heightPerSecond)
            event.coordinates = frame

            let positionedEvents = pos.filter {
                ($0.position.minY >= frame.origin.y && $0.position.minY < frame.maxY) ||
                ($0.position.maxY > frame.origin.y && $0.position.maxY <= frame.maxY)
            }

            event.column = positionedEvents.count
            event.columnCount = positionedEvents.count

            let returnList = eventList.map {
                var event = $0
                if positionedEvents.contains(where: { $0.id == event.id }) {
                    event.columnCount += 1
                }
                return event
            }
            eventList = returnList
            eventList.append(event)

            pos.append(EventPositions(id: event.id, sharePositionWith: positionedEvents.map { $0.id }, position: frame))
        }

        self.events = eventList
    }

    private func calculateOffset(event: Event) -> Double {
        guard let startHour = event.startDate.hour, let dateHour = Date().atHour(startHour) else { return 0 }

        let actualHourHeight = hourHeight + hourSpacing
        let heightPerSecond = (actualHourHeight / 60) / 60
        let secondsSinceStartOfDay = abs(Date().atHour(0)?.timeIntervalSince(dateHour) ?? 0)
        return secondsSinceStartOfDay * heightPerSecond
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        let appDataModel = AppDataModel()

        // swiftlint:disable force_unwrapping
        let selectedDate = Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 27, hour: 9))!
        let secondDate = Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 27, hour: 10))!
        let thirdDate = Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 27, hour: 7, minute: 15))!
        let fouthDate = Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 27, hour: 7, minute: 30))!
        // swiftlint:enable force_unwrapping
        let events = [
            Event.forPreview(startDate: selectedDate),
            Event.forPreview(id: "2", startDate: secondDate, activity: Activity.forPreview(id: "2", type: .socialActivity)),
            Event.forPreview(id: "3", startDate: selectedDate, activity: Activity.forPreview(id: "3", type: .transport)),
            Event.forPreview(id: "4", startDate: thirdDate, activity: Activity.forPreview(id: "4", type: .socialActivity, duration: 45 * 60)),
            Event.forPreview(id: "5", startDate: fouthDate, activity: Activity.forPreview(id: "5", type: .meal))
        ]
        appDataModel.events = events

        return Group {
            NavigationStack {
                ScheduleView()
                    .environmentObject(appDataModel)
            }
            .previewDisplayName("Light")
            .preferredColorScheme(.light)

            NavigationStack {
                ScheduleView()
                    .environmentObject(appDataModel)
            }
            .previewDisplayName("Dark")
            .preferredColorScheme(.dark)
        }
    }
}

private extension Locale {
    static var is24Hour: Bool {
        guard let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current) else { return false }
        return dateFormat.firstIndex(of: "a") != nil
    }
}
