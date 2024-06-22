//
//  HomeView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 16/6/24.
//

import Charts
import SwiftData
import SwiftUI

enum Field {
    case prompt
    case response
}

struct HomeView: View {
    @EnvironmentObject private var deeplinkManager: DeeplinkStateManager
    @EnvironmentObject private var modalManager: ModalManager

    // MVVM in SwiftData: https://www.youtube.com/watch?v=4-Q14fCm-VE
    @State private var thoughtVm: ThoughtViewModel = .init()

    @AppStorage("userName") private var userName: String = ""
    @Environment(\.modelContext) private var context: ModelContext

    @State var filteredDate: Date = .now

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(getGreeting()) \(userName)")
                .font(.title)
                .bold()
            Text("Time to reflect and grow")
                .foregroundStyle(.secondary)

            HorizontalCalendarView(selectedDate: $filteredDate)
                .padding(.vertical, 10)
                .padding(.bottom, 20)

            ScrollView {
                if thoughtVm.thoughts.isEmpty {
                    EmptyThoughtsView()
                } else {
                    ForEach(thoughtVm.thoughts) { t in
                        NavigationLink {
                            ThoughtDetailView(thought: t)
                        } label: {
                            ThoughtCardView(thought: t)
                        }
                    }

                    //                    Add rectangle at the bottom of scrollview to avoid the navigation bar + navbar gradient
                    Rectangle()
                        .frame(height: 150)
                        .foregroundStyle(.primary.opacity(0))
                }
            }
            .scrollDismissesKeyboard(.interactively)

            Spacer()
        }
        .padding()
        .ignoresSafeArea(.all, edges: .bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $modalManager.addThought) {
            NavigationStack {
                ZStack {
                    Color.background.edgesIgnoringSafeArea(.all)
                    ChoosePromptView(
                        prompt: deeplinkManager.prompt,
                        emotion: deeplinkManager.emotion
                    )
                }
            }
        }
        .foregroundStyle(.primary)
        .background(Color.background)
        .onAppear {
            // MVVM in SwiftData: https://www.youtube.com/watch?v=4-Q14fCm-VE
            thoughtVm.context = context
        }
        .onAppear {
            /// Runs when this view first appears
            thoughtVm.fetchThoughtsForDate(for: filteredDate)
        }
        .onChange(of: modalManager.addThought) { _, _ in
            /// Runs when  the add thought modal is not presented anymore (a.k.a dismissed a.k.a cancelled a.k.a added)
            thoughtVm.fetchThoughtsForDate(for: filteredDate)
        }
        .onChange(of: filteredDate) {
            /// Runs when filteredDate change (for horizontal calendar)
            print("Filtered date changed: \($1)")
            thoughtVm.fetchThoughtsForDate(for: $1)
        }
        .onOpenURL { url in
            print("Received deeplink \(url) \(url.lastPathComponent)")

            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                  let host = components.host
            else {
                print("Invalid URL: \(url)")
                return
            }

            // Switch on the host part of the URL
            switch host {
            case "add":
                deeplinkManager.reset()
                handleAddAction(with: components)
            default:
                print("Unhandled deep link action: \(host)")
            }
        }
    }
}

// MARK: Helper functions

extension HomeView {
    func getGreeting() -> LocalizedStringResource {
        let currentDate = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentDate)

        switch hour {
        case 0 ..< 12:
            return "Good Morning,"
        case 12 ..< 18:
            return "Good Afternoon,"
        default:
            return "Good Evening,"
        }
    }

    func handleAddAction(with: URLComponents) {
        modalManager.addThought = true

        let (prompt, emotion) = extractPromptAndEmotion(from: with)

        guard let truePrompt = prompt, let trueEmotion = emotion else {
            print("No prompt nor emotion")
            return
        }

        print("Prompt from deeplink: \(truePrompt)")
        print("Emotion from deeplink: \(trueEmotion)")

        deeplinkManager.prompt = truePrompt
        deeplinkManager.emotion = trueEmotion
    }

    func extractPromptAndEmotion(from components: URLComponents) -> (prompt: String?, emotion: Emotion?) {
        // Access query parameters
        let queryItems = components.queryItems ?? []

        // Extract prompt and emotion if available
        var prompt: String?
        var emotion: String?

        for queryItem in queryItems {
            switch queryItem.name {
            case "prompt":
                prompt = queryItem.value
            case "emotion":
                emotion = queryItem.value
            default:
                continue
            }
        }

        // Perform action based on prompt and emotion values
        guard let truePrompt = prompt, let emotion = emotion, let trueEmotion = Emotion(rawValue: emotion) else {
            return (nil, nil)
        }

        return (truePrompt, trueEmotion)
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .modelContainer(SampleData.shared.modelContainer)
            .environmentObject(ModalManager())
            .environmentObject(DeeplinkStateManager())
    }
}
