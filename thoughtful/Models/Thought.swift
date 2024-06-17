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
    let thought_prompt: String
    let thought_response: String
    let date_created: Date

    let location: String?
    let music: String?
    var emotion: Emotion?

    var emotionExists: Bool {
        emotion != nil
    }

    var locationExists: Bool {
        location != nil
    }

    var musicExists: Bool {
        music != nil
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
