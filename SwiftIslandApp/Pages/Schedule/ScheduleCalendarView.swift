//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct ScheduleCalendarView: View {
    let hours: [String]
    @Binding var hourSpacing: Double
    @Binding var hourHeight: Double

    var body: some View {
        VStack(alignment: .leading, spacing: hourSpacing) {
            ForEach(hours, id: \.self) { hour in
                HStack {
                    Text(hour)
                        .font(Font.caption)
                        .minimumScaleFactor(0.7)
                        .frame(width: 35, height: hourHeight, alignment: .trailing)
                        .foregroundColor(.secondary)
                        .dynamicTypeSize(.small ... .large)
                    VStack {
                        Divider()
                            .foregroundColor(.secondary.opacity(0.9))
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}


struct ScheduleCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScheduleCalendarView(hours: ["12 am", "1 am", "2 am", "3 am", "4 am"], hourSpacing: .constant(24), hourHeight: .constant(30))
            ScheduleCalendarView(hours: ["12 am", "1 am", "2 am", "3 am", "4 am"], hourSpacing: .constant(24), hourHeight: .constant(30))
                .previewDisplayName("Dynamic size XXL")
                .environment(\.sizeCategory, .extraExtraLarge)
            ScheduleCalendarView(hours: ["12 am", "1 am", "2 am", "3 am", "4 am"], hourSpacing: .constant(24), hourHeight: .constant(30))
                .previewDisplayName("Dynamic size XXS")
                .environment(\.sizeCategory, .extraSmall)
        }
    }
}
