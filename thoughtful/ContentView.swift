//
//  ContentView.swift
//  thoughtful
//
//  Created by Nabil Ridhwan on 13/6/24.
//

import SwiftData
import SwiftUI
import TipKit

struct ContentView: View {
    var body: some View {
        NavigationStack {
//            TabView{
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

//                HomeView()
//                    .tabItem {
//                        Label("Calendar", systemImage: "calendar")
//                    }
//
//                HomeView()
//                    .tabItem {
//                        Label("Stats", systemImage: "chart.bar")
//                    }
//
//                SettingsView()
//                    .tabItem {
//                        Label("Settings", systemImage: "gear")
//                    }
//            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
        .preferredColorScheme(.dark)
        .task {
            try? Tips.configure([
                .datastoreLocation(.applicationDefault),
            ])
        }
}
