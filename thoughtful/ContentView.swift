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

    @State var selectedTab: Int = 0
    @EnvironmentObject private var modalManager: ModalManager

    var body: some View {
        NavigationStack {
            if !doneOnboarding {
                MainOnboardingView(
                    doneOnboarding: $doneOnboarding
                )
            } else {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tag(0)

                    EmptyView()
                        .tag(1)

                    EmptyView()
                        .tag(3)

                    SettingsView()
                        .tag(4)
                }
                .overlay(alignment: .bottom) {
                    CustomTabBarView(
                        selectedTab: $selectedTab,
                        showAddModal: $modalManager.addThought
                    )
                }
                .onChange(of: selectedTab) { _, _ in
                    if selectedTab == 2 {
                        print("add pressed")
                    }
                }
                .ignoresSafeArea(.all, edges: .bottom)
            }
        }

        // MARK: UNCOMMENT THE LINE BELOW TO ENABLE ONBOARDING SCREEN

        //        .onAppear {
        //            doneOnboarding = false
        //        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
        .task {
            // MARK: UNCOMMENT THE LINE BELOW TO FORCEFULLY SHOW TIPS

//            try? Tips.resetDatastore()
            try? Tips.configure([
                .datastoreLocation(.applicationDefault),
            ])
        }
}
