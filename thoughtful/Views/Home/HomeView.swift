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

class DeeplinkViewModel: ObservableObject {
    var prompt: String = ""
    var emotion: Emotion?

    func reset() {
        prompt = ""
        emotion = nil
    }
}

struct HomeView: View {
    @EnvironmentObject var dlvm: DeeplinkViewModel

    @AppStorage("userName") private var userName: String = ""

    @Environment(\.modelContext) private var context: ModelContext

    @State var thoughts: [Thought] = []
    @State var filteredDate: Date = .now

    //    Present modal on pressing "Add Thought"
    @Binding var isAddThoughtPresented: Bool
    @State var isSettingsPresented = false

    //    Bases on focusedField in onChange to have animations
    @State private var isFormActive: Bool = false

    //    For handling what 'Next' button does, check out the binding with the TextField and also the onSubmit
    @FocusState private var focusedField: Field?

    func getGreeting() -> String {
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
                if thoughts.isEmpty {
                    EmptyThoughtsView()
                } else {
                    ForEach(thoughts) { thought in
                        NavigationLink {
                            ThoughtDetailView(thought: thought)
                        } label: {
                            ThoughtCardView(thought: thought)
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
        .onChange(of: isFormActive) { _, _ in
            print("isFormActive changed \(isFormActive)")
        }
        .onChange(of: focusedField) { _, newValue in
            withAnimation(.easeOut(duration: 0.3)) {
                if newValue == nil {
                    isFormActive = false
                } else {
                    isFormActive = true
                }
            }
            print("focusedField changed:")
            print(newValue != nil ? newValue! : "nil")
        }
        .padding()
        .ignoresSafeArea(.all, edges: .bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $isAddThoughtPresented) {
            NavigationStack {
                ZStack {
                    Color.background.edgesIgnoringSafeArea(.all)
                    ChoosePromptView(
                        prompt: dlvm.prompt,
                        emotion: dlvm.emotion
                    )
                    .padding()
                }
            }
        }

        .sheet(isPresented: $isSettingsPresented) {
            NavigationStack {
                ZStack {
                    Color.background.edgesIgnoringSafeArea(.all)
                    SettingsView(
                    ).padding()
                    //                    AddNewThoughtView(
                    //                        date: $filteredDate
                    //                    )
                }
                .navigationTitle("Settings")
            }
        }

        .foregroundStyle(.primary)
        .background(Color.background)
        .toolbar {
            //            ToolbarItem {
            //                Button {
            //                    withAnimation {
            //                        isAddThoughtPresented.toggle()
            //                    }
            //
            //                } label: {
            //                    Label("Search", systemImage: "magnifyingglass")
            //                        .labelStyle(.iconOnly)
            //                }
            //            }

            ToolbarItem {
                Button {
                    withAnimation {
                        isSettingsPresented.toggle()
                    }
                } label: {
                    Image(systemName: "calendar")
                }.overlay {
                    DatePicker(
                        "",
                        selection: $filteredDate,
                        in: Date.distantPast ... Date(),
                        displayedComponents: [.date]
                    )
                    .labelsHidden()
                    .blendMode(.destinationOver) // MARK: use this extension to keep the clickable functionality

//                    .onChange(of: , perform: { value in
//                        isChild = checkAge(date:birthday)
//                    })
                }
            }
        }
        .onAppear {
            /// Runs when this view first appears
            refetchThoughtsForDate(filteredDate)
        }
        .onChange(of: isAddThoughtPresented) { _, _ in
            /// Runs when  the add thought modal is not presented anymore (a.k.a dismissed a.k.a cancelled a.k.a added)
            refetchThoughtsForDate(filteredDate)
        }
        .onChange(of: filteredDate) { _, newValue in
            /// Runs when filteredDate change (for horizontal calendar)
            print("Filtered date changed")
            refetchThoughtsForDate(newValue)
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
                dlvm.reset()
                handleAddAction(with: components)
            default:
                print("Unhandled deep link action: \(host)")
            }
        }
    }
}

// MARK: Helper functions

extension HomeView {
    // The reason one might think "Why didn't I just use @Query or call the Query() method and pass in the predicate. Trust me, I ChatGPT-ed and looked at the docs so long that it didn't work. self is not mutating. But the docs shows the code to mutate the state. It's confusing so I resorted to manually fetching using a fetch descriptor in hopes that its better

    func refetchThoughtsForDate(_ date: Date) {
        let fetchDescriptor = FetchDescriptor<Thought>(
            predicate: Thought.predicate(searchDate: date),
            sortBy: [
                SortDescriptor(\.date_created, order: .reverse),
            ]
        )

        do {
            try withAnimation {
                thoughts = try context.fetch(fetchDescriptor)
            }
        } catch {
            print("Error while fetching thoughts \(error)")
        }
    }

    func handleAddAction(with: URLComponents) {
        isAddThoughtPresented = true

        let (prompt, emotion) = extractPromptAndEmotion(from: with)

        guard let truePrompt = prompt, let trueEmotion = emotion else {
            print("No prompt nor emotion")
            return
        }

        print("Prompt from deeplink: \(truePrompt)")
        print("Emotion from deeplink: \(trueEmotion)")

        dlvm.prompt = truePrompt
        dlvm.emotion = trueEmotion
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
        HomeView(
            isAddThoughtPresented: .constant(false)
        )
        .modelContainer(SampleData.shared.modelContainer)
    }
}
