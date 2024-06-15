//
//  QuickAction.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 16/6/24.
//

import Foundation
import UIKit

enum QuickAction: Hashable {
    case add
}

class QuickActionsManager: ObservableObject {
    
    static let instance = QuickActionsManager()
    
    @Published var quickAction: QuickAction? = nil
    
    func handleQuickActionItem(_ item: UIApplicationShortcutItem) {
        print("handleQuickActionItem called")
        print(item)
        if item.type == "add" {
            quickAction = .add
        }
    }
}
