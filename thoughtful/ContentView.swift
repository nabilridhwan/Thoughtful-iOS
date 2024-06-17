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
    @AppStorage("doneOnboarding") private var doneOnboarding: Bool = false

    var body: some View {
        NavigationStack {
            if !doneOnboarding {
                MainOnboardingView(
                    doneOnboarding: $doneOnboarding
                )
            } else {
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
        .onAppear {
            doneOnboarding = false
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
