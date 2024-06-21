//
//  DeeplinkStateManager.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 21/6/24.
//

import Foundation

class DeeplinkStateManager: ObservableObject {
    var prompt: String = ""
    var emotion: Emotion?

    func reset() {
        prompt = ""
        emotion = nil
    }
}
