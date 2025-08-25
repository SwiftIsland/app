//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SwiftIslandDataLogic

struct EventView: View {
    let event: Event

    // For opening Event details
    @State private var showEventSheet = false

    var body: some View {
        let mainColor = event.activity.type.color
        let endDate = event.endDate

        VStack {
            VStack {
                VStack(alignment: .leading) {
                    Text(event.activity.title)
                        .foregroundColor(mainColor)
                        .font(.caption)
                        .padding(.top, 4)
                        .fontWeight(.semibold)
                        .dynamicTypeSize(.small ... .large)
                    if (event.duration / 60) < 60 {
                        if event.columnCount > 0 {
                            Text("\(event.startDate.formatted(date: .omitted, time: .shortened)), \(formatDuration(event.duration))")
                                .foregroundColor(mainColor)
                                .font(.caption2)
                                .dynamicTypeSize(.small ... .large)
                        } else {
                            Text("\(event.startDate.formatted(date: .omitted, time: .shortened)) - \(endDate.formatted(date: .omitted, time: .shortened)), \(formatDuration(event.duration))")
                                .foregroundColor(mainColor)
                                .font(.caption2)
                                .dynamicTypeSize(.small ... .large)
                        }
                    } else {
                        Text("\(event.startDate.formatted(date: .omitted, time: .shortened)) - \(endDate.formatted(date: .omitted, time: .shortened))")
                            .foregroundColor(mainColor)
                            .font(.caption2)
                            .dynamicTypeSize(.small ... .large)
                        Text("Duration: \(formatDuration(event.duration))")
                            .foregroundColor(mainColor)
                            .font(.caption2)
                            .dynamicTypeSize(.small ... .large)
                    }
                    Spacer()
                }
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .background(mainColor.opacity(0.20), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay {
                    HStack {
                        Rectangle()
                            .fill(mainColor)
                            .frame(maxHeight: .infinity, alignment: .leading)
                            .frame(width: 4)
                        Spacer()
                    }
                }
            }
            .foregroundColor(.primary)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(mainColor, lineWidth: 1)
                    .frame(maxHeight: .infinity)
            }
            .mask(
                RoundedRectangle(cornerRadius: 6)
                    .frame(maxHeight: .infinity)
            )
        }
        .onTapGesture {
            showEventSheet = true
        }
        .sheet(isPresented: $showEventSheet) {
            EventDetailsView(event: event)
                .presentationDetents([.medium])
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let totalMinutes = Int(duration / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        if totalMinutes < 60 {
            // Less than 1 hour: show as minutes only
            return "\(totalMinutes) min"
        } else if minutes == 0 {
            // Round hours: show as "X hours"
            return hours == 1 ? "1 hour" : "\(hours) hours"
        } else {
            // Mixed hours and minutes: show as "XhYm"
            return "\(hours)h\(minutes)m"
        }
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        let event = Event.forPreview()

        Group {
            EventView(event: event)
                .previewDisplayName("Normal")
            EventView(event: event)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
                .previewDisplayName("XXXL")
            EventView(event: event)
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("XS")
        }
    }
}
