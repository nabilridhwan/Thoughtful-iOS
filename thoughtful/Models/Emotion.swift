//
//  Emotion.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 15/6/24.
//

import Foundation

enum Emotion: Codable, CaseIterable {
    case scared
    case sad
    case angry
    case embarassed
    case neutral
    case playful
    case loved
    case happy
    case excited
    case grateful
    
    var description: String {
        switch self {
        case .scared: return "scared"
        case .sad: return "sad"
        case .angry: return "angry"
        case .embarassed: return "embarassed"
        case .neutral: return "neutral"
        case .playful: return "playful"
        case .loved: return "loved"
        case .happy: return "happy"
        case .excited: return "excited"
        case .grateful: return "grateful"
        }
    }
}
