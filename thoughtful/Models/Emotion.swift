//
//  Emotion.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 15/6/24.
//

import Foundation
import SwiftUI

enum Emotion: String, Codable, CaseIterable {
    case terrible
    case bad
    case okay
    case happy
    case awesome

    var rawValue: String {
        switch self {
        case .terrible: return "terrible"
        case .bad: return "bad"
        case .okay: return "okay"
        case .happy: return "happy"
        case .awesome: return "awesome"
        }
    }

    init?(rawValue: String) {
        switch rawValue {
        case "terrible": self = .terrible
        case "bad": self = .bad
        case "okay": self = .okay
        case "happy": self = .happy
        case "awesome": self = .awesome
        default: return nil
        }
    }

//    var description: String {
//    }

    func getColor() -> Color {
        switch self {
        case .terrible: return Color.emotionTerrible
        case .bad: return Color.emotionBad
        case .okay: return Color.emotionOkay
        case .happy: return Color.emotionHappy
        case .awesome: return Color.emotionAwesome
        }
    }

    func getIcon() -> ImageResource {
        switch self {
        case .terrible: return .terrible
        case .bad: return .sad
        case .okay: return .neutral
        case .happy: return .happy
        case .awesome: return .awesome
        }
    }

    func getIconNoFace() -> ImageResource {
        switch self {
        case .terrible: return .terribleNoFace
        case .bad: return .sadNoFace
        case .okay: return .neutralNoFace
        case .happy: return .happyNoFace
        case .awesome: return .awesomeNoFace
        }
    }
}
