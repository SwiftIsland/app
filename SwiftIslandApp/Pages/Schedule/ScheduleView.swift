//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ScheduleView: View {

    @EnvironmentObject private var appDataModel: AppDataModel

    @State private var hourSpacing = 24.0
    @State private var hourHeight = 25.0
    @State private var selectedDate: Date? = Calendar.current.date(from: DateComponents(year: 2023, month: 9, day: 4))
    @State private var showPopover = false

    @State private var selectedDayTag = 4

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

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMdd")
        return dateFormatter
    }()

    var body: some View {
        ScrollView {
            ZStack {
                ScheduleCalendarView(hours: hours, hourSpacing: $hourSpacing, hourHeight: $hourHeight)

                let calendar = Calendar.current
                if let selectedDate, calendar.isDateInToday(selectedDate) {
                    ScheduleTimelineView(hourSpacing: $hourSpacing, hourHeight: $hourHeight)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 62)
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
                            .popover(isPresented: $showPopover,
                                     attachmentAnchor: .point(.bottom),
                                     arrowEdge: .top,
                                     content: {
                                VStack(alignment: .trailing) {
                                    Text("Select day")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Picker("What is your favorite color?", selection: $selectedDayTag) {
                                        Text("Monday").tag(4) // 4th of September
                                        Text("Tuesday").tag(5)
                                        Text("Wednesday").tag(6)
                                        Text("Thursday").tag(7)
                                    }
                                    .pickerStyle(.segmented)
                                }
                                .padding()
                                .presentationCompactAdaptation(.popover)
                            })
                    }
                }
            }
        }
        .onChange(of: selectedDayTag) { newValue in
            self.selectedDate = Calendar.current.date(from: DateComponents(year: 2023, month: 9, day: selectedDayTag))
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        let appDataModel = AppDataModel()

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
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
        return dateFormat.firstIndex(of: "a") != nil
    }
}
