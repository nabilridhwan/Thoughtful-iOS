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

    // The reason one might think "Why didn't I just use @Query or call the Query() method and pass in the predicate. Trust me, I ChatGPT-ed and looked at the docs so long that it didn't work. self is not mutating. But the docs shows the code to mutate the state. It's confusing so I resorted to manually fetching using a fetch descriptor in hopes that its better

    func fetchThoughtsForDate(_ date: Date) {
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
