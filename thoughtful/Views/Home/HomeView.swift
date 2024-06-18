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
    @AppStorage("userName") private var userName: String = ""

    @Environment(\.modelContext) private var context: ModelContext

    @State var thoughts: [Thought] = []

    @State var filteredThoughts: [Thought] = []

    @State var filteredDate: Date = .now

    //    Present modal on pressing "Add Thought"
    @State var isAddThoughtPresented = false
    @State var isSettingsPresented = false

    //    Bases on focusedField in onChange to have animations
    @State private var isFormActive: Bool = false

    //    For handling what 'Next' button does, check out the binding with the TextField and also the onSubmit
    @FocusState private var focusedField: Field?

    @State var emotion: Emotion?

    let addThoughtTip = AddThoughtTip()

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
                        .padding(.horizontal, 40)
                        .padding(.top, 80)
                        .padding(.bottom, 20)
                } else {
                    ForEach(thoughts) { thought in
                        NavigationLink {
                            ThoughtDetailView(thought: thought)
                        } label: {
                            ThoughtCardView(thought: thought)
                        }
                    }
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
                    ).padding()
                    //                    AddNewThoughtView(
                    //                        date: $filteredDate
                    //                    )
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
            ToolbarItem {
                Button {
                    withAnimation {
                        isAddThoughtPresented.toggle()
                    }

                    addThoughtTip.invalidate(reason: .actionPerformed)

                } label: {
                    Label("Add Thought", systemImage: "plus.circle")
                        .labelStyle(.iconOnly)
                }.popoverTip(addThoughtTip)
            }

            ToolbarItem {
                Button {
                    withAnimation {
                        isSettingsPresented.toggle()
                    }
                } label: {
                    Image(systemName: "gear")
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
            #warning("Any deeplink to the app will open the Add Thought modal")
            if url != nil {
                isAddThoughtPresented = true
            }
            print("Received deeplink \(url) \(url.lastPathComponent)")
        }
    }
}

// MARK: Helper functions

extension HomeView {
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
}

#Preview {
    NavigationStack {
        HomeView()
            .modelContainer(SampleData.shared.modelContainer)
    }
}
