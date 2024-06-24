//
//  Thought.swift
//  thoughtful
//
//  Created by Nabil Ridhwan on 13/6/24.
//

import SwiftData
import SwiftUI

@Model
class Thought: ObservableObject {
    var thought_prompt: String
    var thought_response: String
    var date_created: Date

    var location: String?
    var music: String?
    var emotion: Emotion?

    @Attribute(.externalStorage) var photos: [Data] = []

    var emotionExists: Bool {
        emotion != nil
    }

    var locationExists: Bool {
        location != nil
    }

    var musicExists: Bool {
        music != nil
    }

    var photo: Data? {
        photos.isEmpty ? nil : photos.last
    }

    // https://developer.apple.com/documentation/swiftdata/filtering-and-sorting-persistent-data#Define-a-filter-using-a-predicate
    static func predicate(searchDate: Date) -> Predicate<Thought> {
        let calendar = Calendar.autoupdatingCurrent
        let start = calendar.startOfDay(for: searchDate)
        let end = calendar.date(byAdding: .init(day: 1), to: start) ?? start

        return #Predicate<Thought> {
            thought in
            thought.date_created > start && thought.date_created < end
        }
    }

    // Date range predicate (for upcoming calendar feature)
    static func predicate(startDate: Date, endDate: Date) -> Predicate<Thought> {
        let calendar = Calendar.autoupdatingCurrent
        let start = calendar.startOfDay(for: startDate)
        let end = endDate

        return #Predicate<Thought> {
            thought in
            thought.date_created > start && thought.date_created < end
        }
    }

    init() {
        thought_prompt = ""
        thought_response = ""
        date_created = Date.now
        location = nil
        music = nil
        emotion = nil
    }

    init(thought_prompt: String, thought_response: String, date_created: Date, location: String? = nil, music: String? = nil, emotion: Emotion? = nil) {
        self.thought_prompt = thought_prompt
        self.thought_response = thought_response
        self.date_created = date_created
        self.location = location
        self.music = music
        self.emotion = emotion
    }
}
