//
//  HorizontalCalendarView.swift
//  thoughtful
//
//  Created by Nabil Ridhwan on 13/6/24.
//

import SwiftUI

var dates: [Date] = [
    Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
    Calendar.current.date(byAdding: .day, value: -6, to: Date())!,
    Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
    Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
    Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
    Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
    Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
    Calendar.current.date(byAdding: .day, value: 0, to: Date())!
]

let dateFormatter = DateFormatter()

func getDayOfWeekFromDate(date: Date) -> String {
    dateFormatter.dateFormat = "EEE"
    let dayInWeek = dateFormatter.string(from: date)
    return dayInWeek
}

func getDayFromDate(date: Date) -> String {
    dateFormatter.dateFormat = "d"
    let dayInWeek = dateFormatter.string(from: date)
    return dayInWeek
}

func isToday(_ date1: Date, _ date2: Date) -> Bool {
    return getDayFromDate(date: date1) == getDayFromDate(date: date2)
}

struct HorizontalCalendarView: View {
    @Binding var selectedDate: Date;
    
    var body: some View {
        ZStack{
            HStack{
                ForEach(dates, id:\.hashValue) {
                    date in
                    Button {
                        withAnimation{
                            selectedDate = date;
                        }
                    } label: {
                        ZStack {
                            if isToday(selectedDate, date) {
                                RoundedRectangle(cornerRadius: 24)
                                    .frame(width: 55, height: 72)
                                .foregroundStyle(.cardAttribute)
                                
                            }

                            VStack{
                                Text("\(getDayOfWeekFromDate(date: date))")
                                
                                Text("\(getDayFromDate(date: date))")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .foregroundStyle(.white.opacity(isToday(selectedDate, date) ? 1.0 : 0.5))
                        }
                    }
                    
                }
            }
        }.frame(maxHeight: 50)
    }
}

//
//#Preview {
//    Group{
//        HorizontalCalendarView(selectedDate: $selectedDate)
//    }
//}
