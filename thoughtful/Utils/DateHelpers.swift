//
//  DateHelpers.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 17/6/24.
//

import Foundation

enum DateHelpers {
    static let dateFormatter = DateFormatter()

    static func getDayOfWeekFromDate(date: Date) -> String {
        dateFormatter.dateFormat = "EEE"
        let dayInWeek = dateFormatter.string(from: date)
        return dayInWeek
    }

    static func getDayFromDate(date: Date) -> String {
        dateFormatter.dateFormat = "d"
        let dayInWeek = dateFormatter.string(from: date)
        return dayInWeek
    }

    static func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }

    static func isAfterDate2(_ date1: Date, _ date2: Date) -> Bool {
        return date1 > date2
    }

    static func findFirstDateOfTheWeek(_ date: Date) -> Date {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let daysToSubtract = weekday - calendar.firstWeekday
        return calendar.date(byAdding: .day, value: -daysToSubtract, to: date)!
    }

    static func findLastDateOfTheWeek(_ date: Date) -> Date {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let daysToAdd = (calendar.firstWeekday + 6 - weekday) % 7
        return calendar.date(byAdding: .day, value: daysToAdd, to: date)!
    }

    static func getDatesForWeek(_ date: Date) -> [Date] {
        let calendar = Calendar.current
        let firstDateOfTheWeek = findFirstDateOfTheWeek(date)
        let lastDateOfTheWeek = findLastDateOfTheWeek(date)

        var dates: [Date] = Array(repeating: Date(), count: 7)

        dates[0] = firstDateOfTheWeek
        dates[6] = lastDateOfTheWeek

        for i in 1 ..< 6 {
            dates[i] = calendar.date(byAdding: .day, value: i, to: firstDateOfTheWeek)!
        }

        return dates
    }
}
