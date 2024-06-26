//
//  SampleData.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 15/6/24.
//

import Foundation
import SwiftData

@MainActor
class SampleData {
    static var shared: SampleData = .init()

    let modelContainer: ModelContainer

    var context: ModelContext {
        modelContainer.mainContext
    }

    private init() {
//        Create model context
        let schema = Schema([
            Thought.self,
        ])

        let modelConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfig])
        } catch {
            fatalError("[SampleData] There was a problem creating the model context: \(error)")
        }
    }

    let sampleData: [Thought] = [
        Thought(thought_prompt: "What are three things that I am grateful for?", thought_response: "My Friends, **Nazrul** for _checking up on me_, The movie night on Discord", date_created: Date.now, location: "Eunos", music: "The Backseat Lovers - Pool House", emotion: .okay),
        Thought(thought_prompt: "What are three things that I am grateful for?", thought_response: "My Friends, Nazrul for checking up on me, The movie night on Discord", date_created: Date.now, location: "Eunos", music: "The Backseat Lovers - Pool House", emotion: .bad),
    ]

    var thought: Thought {
        sampleData[0]
    }
}
