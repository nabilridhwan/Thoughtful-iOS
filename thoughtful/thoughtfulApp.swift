//
//  thoughtfulApp.swift
//  thoughtful
//
//  Created by Nabil Ridhwan on 13/6/24.
//

import SwiftData
import SwiftUI
import TipKit

@main
struct thoughtfulApp: App {
    @AppStorage("theme") var theme: Theme = .system
    @StateObject var dlmgr = DeeplinkStateManager()
    @StateObject var mmgr = ModalManager()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Thought.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(theme.getColorScheme())
                .modelContainer(sharedModelContainer)
                .environmentObject(dlmgr)
                .environmentObject(mmgr)
                .task {
                    try? Tips.configure([
                        .datastoreLocation(.applicationDefault),
                    ])
                }
        }
    }
}
