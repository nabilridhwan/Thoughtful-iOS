//
//  HorizontalCalendarView.swift
//  thoughtful
//
//  Created by Nabil Ridhwan on 13/6/24.
//

import SwiftUI

struct HorizontalCalendarView: View {
    @Binding var selectedDate: Date
    @Namespace var rectNs;

    var weekDates: [Date] {
        DateHelpers.getDatesForWeek()
    }

    var body: some View {
        HStack {
            ForEach(weekDates, id: \.hashValue) {
                date in
                Button {
                    withAnimation {
                        selectedDate = date
                    }
                } label: {
                    ZStack {
                        if DateHelpers.isSameDay(selectedDate, date) {
                            RoundedRectangle(cornerRadius: 24)
                                .frame(width: 55, height: 74)
                                .foregroundStyle(.cardAttribute)
                                .matchedGeometryEffect(id: "Rect", in: rectNs)
                        }
                        VStack {
                            Text("\(DateHelpers.getDayOfWeekFromDate(date: date))")

                            Text("\(DateHelpers.getDayFromDate(date: date))")
                                .font(.title3)
                                .fontWeight(.bold)

                        }.frame(maxWidth: .infinity)
                            .foregroundStyle(.primary.opacity(DateHelpers.isSameDay(selectedDate, date) ? 1.0 : 0.5))
                    }
                }
                .foregroundStyle(.primary.opacity(
                    DateHelpers.isAfterDate2(date, Date.now) ? 0.2 : 1.0
                ))
                .disabled(
                    DateHelpers.isAfterDate2(date, Date.now)
                )
                .scaleEffect(
                    DateHelpers.isSameDay(selectedDate, date) ? 1.1 : 1.0
                )
            }
        }

        .frame(maxHeight: 50)
    }
}

//
// #Preview {
//    Group{
//        HorizontalCalendarView(selectedDate: $selectedDate)
//    }
// }
