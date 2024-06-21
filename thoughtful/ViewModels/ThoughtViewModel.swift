//
//  ThoughtViewModel.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 21/6/24.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
// MVVM in SwiftData: https://www.youtube.com/watch?v=4-Q14fCm-VE
class ThoughtViewModel {
    var context: ModelContext?
    var thoughts: [Thought] = []

    // Fetch thoughts for date
    func fetchThoughtsForDate(for date: Date) {
        print("Fetching thoughts for date: \(date)")

        let fetchDescriptor = FetchDescriptor<Thought>(
            predicate: Thought.predicate(searchDate: date),
            sortBy: [
                SortDescriptor(\.date_created, order: .reverse),
            ]
        )

        do {
            try withAnimation {
                thoughts = try context?.fetch(fetchDescriptor) ?? []
            }
        } catch {
            print("Error while fetching thoughts \(error)")
        }
    }

    // Fetch number of thoughts for date
    func fetchNumberOfThoughtsForDate(for date: Date) -> Int {
        let fetchDescriptor = FetchDescriptor<Thought>(
            predicate: Thought.predicate(searchDate: date),
            sortBy: [
                SortDescriptor(\.date_created, order: .reverse),
            ]
        )

        do {
            return try context?.fetchCount(fetchDescriptor) ?? 0
        } catch {
            return 0
        }
    }
}
