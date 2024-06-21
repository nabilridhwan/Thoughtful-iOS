//
//  ModalManager.swift
//  Handles all modal states and showing
//  Thoughtful
//
//  Created by Nabil Ridhwan on 22/6/24.
//

import Foundation

class ModalManager: ObservableObject {
    @Published var addThought: Bool = false
    @Published var edit: Bool = false
    @Published var confirmDelete: Bool = false
    @Published var customPrompt: Bool = false
    @Published var emotionSelect: Bool = false
}
