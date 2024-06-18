//
//  Thought.swift
//  thoughtful
//
//  Created by Nabil Ridhwan on 13/6/24.
//

import SwiftData
import SwiftUI

@Model
class Thought {
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

    static var empty = Thought(thought_prompt: "", thought_response: "", date_created: Date.now)

    init(thought_prompt: String, thought_response: String, date_created: Date, location: String? = nil, music: String? = nil, emotion: Emotion? = nil) {
        self.thought_prompt = thought_prompt
        self.thought_response = thought_response
        self.date_created = date_created
        self.location = location
        self.music = music
        self.emotion = emotion
    }
}
