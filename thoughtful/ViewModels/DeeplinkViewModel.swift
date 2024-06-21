//
//  DeeplinkViewModel.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 21/6/24.
//

import Foundation

class DeeplinkViewModel: ObservableObject {
    var prompt: String = ""
    var emotion: Emotion?

    func reset() {
        prompt = ""
        emotion = nil
    }
}
