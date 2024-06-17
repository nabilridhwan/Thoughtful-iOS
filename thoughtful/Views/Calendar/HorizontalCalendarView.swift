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

                        //                            if isToday(date, Date()){
                        //                                RoundedRectangle(cornerRadius: 24)
                        //                                    .position(x:4, y:-25)
                        //                                    .frame(width: 5, height: 5)
                        //                                    .foregroundStyle(.white)
                        //
                        //                            }

                        VStack {
                            Text("\(DateHelpers.getDayOfWeekFromDate(date: date))")

                            Text("\(DateHelpers.getDayFromDate(date: date))")
                                .font(.title3)
                                .fontWeight(.bold)

                        }.frame(maxWidth: .infinity)
                            .foregroundStyle(.primary.opacity(DateHelpers.isSameDay(selectedDate, date) ? 1.0 : 0.5))
                    }
                }.scaleEffect(
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
