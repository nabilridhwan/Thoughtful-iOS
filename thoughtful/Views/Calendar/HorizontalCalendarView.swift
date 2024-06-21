//
//  HorizontalCalendarView.swift
//  thoughtful
//
//  Created by Nabil Ridhwan on 13/6/24.
//

import SwiftData
import SwiftUI

// var sample_dates: [Date] {
//    var dates: [Date] = []
//    for i in 1...7 {
//        dates.append(Date.now.advanced(by: TimeInterval(-i*86400)))
//    }
//    return dates.reversed();
// }

struct HorizontalCalendarView: View {
    @Environment(\.modelContext) var context: ModelContext
    @Binding var selectedDate: Date

    @State var dateForWeekDates: Date = .now
    @State var thoughtVm: ThoughtViewModel = .init()

    @Namespace var rectNs;

    @State var weekDates: [Date] = DateHelpers.getDatesForWeek(.now)

    init(selectedDate sd: Binding<Date>) {
        _selectedDate = sd
        dateForWeekDates = selectedDate
        weekDates = DateHelpers.getDatesForWeek(dateForWeekDates)
    }

    var body: some View {
        HStack {
            Button {
                guard let date = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -7, to: dateForWeekDates) else {
                    return
                }

                withAnimation {
                    dateForWeekDates = date
                    weekDates = DateHelpers.getDatesForWeek(date)
                }

            } label: {
                Label("Previous Week", systemImage: "chevron.left")
            }
            .foregroundStyle(.primary.opacity(0.5))
            .labelStyle(.iconOnly)

            ForEach(weekDates, id: \.hashValue) {
                date in

                let hasThoughts = thoughtVm.fetchNumberOfThoughtsForDate(for: date) > 0

                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        selectedDate = date
                    }
                } label: {
                    ZStack(alignment: .center) {
                        if DateHelpers.isSameDay(selectedDate, date) {
                            RoundedRectangle(cornerRadius: 24)
                                .frame(width: 52, height: 80)
                                .foregroundStyle(.cardAttribute)
                                .matchedGeometryEffect(id: "Rect", in: rectNs)
                        }

                        if hasThoughts {
                            Circle()
                                .frame(maxWidth: 6)
                                .offset(y: 31)
                                .opacity(0.2)
                        }

                        VStack {
                            Text("\(DateHelpers.getDayOfWeekFromDate(date: date))")

                            Text("\(DateHelpers.getDayFromDate(date: date))")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .scaleEffect(
                            DateHelpers.isSameDay(selectedDate, date) ? 1.1 : 1.0
                        )
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

            Button {
                guard let date = Calendar.autoupdatingCurrent.date(byAdding: .day, value: 7, to: dateForWeekDates) else {
                    return
                }

                withAnimation {
                    dateForWeekDates = date
                    weekDates = DateHelpers.getDatesForWeek(date)
                }

            } label: {
                Label("Next Week", systemImage: "chevron.right")
            }
            .foregroundStyle(.primary.opacity(0.5))
            .labelStyle(.iconOnly)
        }
        .onAppear {
            thoughtVm.context = context
        }

        .frame(maxHeight: 50)
    }
}

#Preview {
    HorizontalCalendarView(selectedDate: .constant(Date.now))
        .previewLayout(.sizeThatFits)
        .modelContainer(SampleData.shared.modelContainer)
}
