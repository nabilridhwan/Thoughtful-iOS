//
//  Theme.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 21/6/24.
//

import Foundation
import SwiftUI

enum Theme: String, CaseIterable, Identifiable {
    var id: Self { self }

    case system
    case light
    case dark

    func getColorScheme() -> ColorScheme? {
        switch self {
        case .system:
            .none
        case .light:
            .light
        case .dark:
            .dark
        }
    }
}

extension Theme: RawRepresentable {
    var rawValue: String {
        switch self {
        case .system:
            return "system"
        case .light:
            return "light"
        case .dark:
            return "dark"
        }
    }

    init?(rawValue: String) {
        switch rawValue {
        case "system":
            self = .system
        case "light":
            self = .light
        case "dark":
            self = .dark
        default:
            return nil
        }
    }
}
