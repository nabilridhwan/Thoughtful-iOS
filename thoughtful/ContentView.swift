//
//  ContentView.swift
//  thoughtful
//
//  Created by Nabil Ridhwan on 13/6/24.
//

import SwiftUI
import SwiftData
import TipKit

struct ContentView: View {
    var body: some View {
        NavigationStack{
            TabView{
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            
        }
    }
    
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
        .preferredColorScheme(.dark)
        .task {
            try? Tips.configure([
                .datastoreLocation(.applicationDefault)
            ])
        }
}
