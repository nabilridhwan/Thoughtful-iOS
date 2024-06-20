//
//  HorizontalCalendarView.swift
//  thoughtful
//
//  Created by Nabil Ridhwan on 13/6/24.
//

import SwiftUI

// var sample_dates: [Date] {
//    var dates: [Date] = []
//    for i in 1...7 {
//        dates.append(Date.now.advanced(by: TimeInterval(-i*86400)))
//    }
//    return dates.reversed();
// }

struct HorizontalCalendarView: View {
    @Binding var selectedDate: Date
    @Namespace var rectNs;

    var weekDates: [Date] {
        DateHelpers.getDatesForWeek(selectedDate)
    }

    var body: some View {
        HStack {
            ForEach(weekDates, id: \.hashValue) {
                date in
                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        selectedDate = date
                    }
                } label: {
                    ZStack {
                        if DateHelpers.isSameDay(selectedDate, date) {
                            RoundedRectangle(cornerRadius: 24)
                                .frame(width: 52, height: 74)
                                .foregroundStyle(.cardAttribute)
                                .matchedGeometryEffect(id: "Rect", in: rectNs)
                        }
                        VStack {
                            Text("\(DateHelpers.getDayOfWeekFromDate(date: date))")

                            Text("\(DateHelpers.getDayFromDate(date: date))")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        //                        .scaleEffect(
                        //                    DateHelpers.isSameDay(selectedDate, date) ? 1.1 : 1.0
                        //                )
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.primary.opacity(DateHelpers.isSameDay(selectedDate, date) ? 1.0 : 0.5))
                    }
                }

                .foregroundStyle(.primary.opacity(
                    DateHelpers.isAfterDate2(date, Date.now) ? 0.4 : 1.0
                ))
                .disabled(
                    DateHelpers.isAfterDate2(date, Date.now)
                )
            }
        }

        .frame(maxHeight: 50)
    }
}

#Preview {
    HorizontalCalendarView(selectedDate: .constant(Date.now))
        .previewLayout(.sizeThatFits)
}
