//
//  ChoosePromptView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 15/6/24.
//

import SwiftUI
import TipKit

struct ChoosePromptView: View {
    @State var date: Date = .now
    @State var currentTab: String = "choose_prompt"
    @State var showCustomPrompt: Bool = false

    @State var newThought: Thought = .init(thought_prompt: "", thought_response: "", date_created: Date.now)

    var addCustomPromptTip = AddCustomPromptTip()

    func handlePressPrompt(_ p: String) {
        withAnimation {
            newThought.thought_prompt = p
            currentTab = "add_thought"
        }
    }

    //    Empty constructor
    init() {}

    //    Constructor for deeplink
    init(prompt: String, emotion: Emotion?) {
        newThought.thought_prompt = prompt
        newThought.emotion = emotion

        print("Using deeplink constructor for ChoosePromptView")
        print("New Thought Prompt: \(prompt)")
        print("New Thought Emotion: \(emotion)")
        print("Current Tab: \(currentTab)")

        if !prompt.isEmpty {
            _currentTab = State(initialValue: "add_thought")
        }
    }

    func changeTab() {
        currentTab = "add_thought"
    }

    var body: some View {
        TabView(selection: $currentTab) {
            VStack(alignment: .leading) {
                Text("Choose a prompt")
                    .font(.title)
                    .bold()

                ScrollView {
                    Button {
                        showCustomPrompt = true
                        addCustomPromptTip.invalidate(reason: .actionPerformed)
                        newThought.thought_prompt = ""
                    } label: {
                        Text("Custom Prompt")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.cardAttribute, in: RoundedRectangle(cornerRadius: 24))
                    .popoverTip(addCustomPromptTip)

                    ForEach(gratitudeQuestions, id: \.self) { p in
                        Button {
                            handlePressPrompt(p)
                        } label: {
                            Text(p)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.card, in: RoundedRectangle(cornerRadius: 24))
                    }
                }
            }
            .tag("choose_prompt")

            ThoughtDetailForm(
                thought: newThought,
                date: $date
            )
            .tag("add_thought")
        }
        .alert("Add Custom Prompt", isPresented: $showCustomPrompt) {
            Button("Cancel", role: .cancel) {
                newThought.thought_prompt = ""
            }
            Button("OK") {
                currentTab = "add_thought"
            }

            TextField("Type your custom prompt", text: $newThought.thought_prompt)
                .lineLimit(3, reservesSpace: true)
        }
        .onAppear {
            print("On Appear Choose Prompt View")
            print("New Thought Prompt: \(newThought.thought_prompt)")
        }
        .ignoresSafeArea(edges: .bottom)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.primary)
        .background(Color.background)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

#Preview {
    ChoosePromptView()
}
