//
//  AddNewThoughtView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 15/6/24.
//

import SwiftUI

struct AddNewThoughtView: View {
    @ObservedObject var thought: Thought

    //    If the user clicks cancel
    @State var originalThought: Thought = .init()

    //    Date Created
    @Binding var date: Date

    @Environment(\.dismiss) var dismiss;
    //    Model Context for Thoughts (SwiftData)
    @Environment(\.modelContext) var modelContext;

    //    @State var showPromptModal: Bool = false
    @State var showEmotionModal: Bool = false

    //    For handling what 'Next' button does, check out the binding with the TextField and also the onSubmit
    @FocusState private var focusedField: Field?

    @State var photo: UIImage?

    var editMode: Bool = false

    init(thought: Thought, date: Binding<Date>, editMode: Bool = false) {
        self.thought = thought
        _date = date
        self.editMode = editMode
    }

    var isSubmittingDisabled: Bool {
        thought.thought_prompt.isEmpty || thought.thought_response.isEmpty
    }

    var confirmationText: String {
        editMode ? "Save" : "Add"
    }

    var body: some View {
        VStack(alignment: .leading) {
            if photo != nil {
                Image(uiImage: photo!)
                    .resizable()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Form
            //            VStack(alignment: .leading) {
            Text(thought.thought_prompt)
                .font(.title3)
                .bold()
            TextField("Type your reply...", text: $thought.thought_response, axis: .vertical)
                .submitLabel(.done)
                .lineLimit(4, reservesSpace: true)
                .focused($focusedField, equals: .response)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.cardAttribute)
                }
            //            }
            //            .sheet(isPresented: $showPromptModal) {
            //                ZStack {
            //                    Color.background.ignoresSafeArea()
            //                    ChoosePromptView(prompt: $prompt)
            //                        .padding()
            //                        .presentationDetents([.medium])
            //                }.ignoresSafeArea(edges: .bottom)
            //            }

            if thought.emotionExists {
                ThoughtCardAttrbuteView(
                    icon: Image(thought.emotion!.getIcon()),
                    text: thought.emotion!.description.capitalized,
                    backgroundColor: thought.emotion!.getColor(),
                    foregroundColor: .black.opacity(0.6),
                    shadowColor: thought.emotion!.getColor()
                )
            }

            // Toolbar !
            ToolbarView(
                thought: thought,
                showEmotionModal: $showEmotionModal,
                focusedField: _focusedField
            )
            .padding(.vertical, 20)

            Spacer()
        }
        .onAppear {
            originalThought = Thought(
                thought_prompt: thought.thought_prompt,
                thought_response: thought.thought_response,
                date_created: thought.date_created,
                location: thought.location,
                music: thought.music,
                emotion: thought.emotion
            )

            //            Set the original photos
            originalThought.photos = thought.photos
        }
        .sheet(isPresented: $showEmotionModal) {
            ZStack {
                Color.background.ignoresSafeArea()
                ChooseEmotionView(
                    emotion: $thought.emotion
                )
                .padding()
                .presentationDetents([.medium])
            }.ignoresSafeArea(edges: .bottom)
        }
        .task {
            DispatchQueue.main.async {
                if !thought.photos.isEmpty, let loadedPhoto = UIImage(data: thought.photos[0]) {
                    withAnimation {
                        self.photo = loadedPhoto
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    //                    Set back the thought as the original thought
                    handleCancel()

                    dismiss()
                }
            }

            ToolbarItem {
                Button(confirmationText) {
                    handleAdd()
                }.disabled(isSubmittingDisabled)
            }
        }
        .onChange(of: thought.thought_response) { _, n in
            print(n)
        }
        .onChange(of: thought.photos) { _, newValue in
            if !newValue.isEmpty {
                DispatchQueue.main.async {
                    if let loadedPhoto = UIImage(data: newValue[0]) {
                        withAnimation {
                            self.photo = loadedPhoto
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.primary)
        .background(Color.background)
        .onAppear {
            focusedField = .prompt
        }
    }
}

extension AddNewThoughtView {
    func handleCancel() {
        print("Cancelling thought add/edit – Setting back to original thought")

        thought.thought_prompt = originalThought.thought_prompt
        thought.thought_response = originalThought.thought_response
        thought.emotion = originalThought.emotion
        thought.photos = originalThought.photos
        thought.music = originalThought.music
        thought.location = originalThought.location
    }

    func handleAdd() {
        print("Adding new thought")
        //        thought.thought_prompt = prompt
        thought.date_created = date
        //        thought.thought_response = response
        //
        //        if emotion != nil {
        //            thought.emotion = emotion
        //        }

        modelContext.insert(thought)

        dismiss()
    }
}

#Preview {
    NavigationStack {
        AddNewThoughtView(thought: .init(thought_prompt: "What do you think about fans?", thought_response: "", date_created: Date.now), date: .constant(Date.now))
    }
}
