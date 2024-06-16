//
//  ContentView.swift
//  thoughtful
//
//  Created by Nabil Ridhwan on 13/6/24.
//

import SwiftUI
import SwiftData

enum Field {
    case prompt;
    case response;
}

let gratitudeQuestions = [
    "What are three things you are grateful for today?",
    "Who is someone you feel especially grateful to have in your life? Why?",
    "What is a recent experience that made you feel grateful?",
    "What is something you are grateful for that you usually take for granted?",
    "What is a personal quality or ability you are grateful for?",
    "What is a place you feel grateful for and why?",
    "What is a challenge you faced that you are now grateful for?",
    "What is something beautiful you saw recently that you are thankful for?",
    "What are you grateful for in your current job or daily routine?",
    "What technology or modern convenience are you grateful for?"
]

struct ContentView: View {
    var body: some View {
        HomeView()
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}
