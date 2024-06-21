//
//  ThoughtDetailForm.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 15/6/24.
//

import SwiftUI

struct ThoughtDetailForm: View {
    @State var thoughtVm: ThoughtViewModel = .init()
    @EnvironmentObject var deeplinkManager: DeeplinkStateManager
    @EnvironmentObject var modalManager: ModalManager

    @ObservedObject var thought: Thought

    //    If the user clicks cancel
    @State var originalThought: Thought = .init()

    @Environment(\.dismiss) var dismiss;
    //    Model Context for Thoughts (SwiftData)
    @Environment(\.modelContext) var context;

    //    For handling what 'Next' button does, check out the binding with the TextField and also the onSubmit
    @FocusState private var focusedField: Field?

    @State var photo: UIImage?

    var editMode: Bool = false

    init(thought: Thought, editMode: Bool = false) {
        self.thought = thought
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
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        Button {
                            thought.photos.removeAll()
                        } label: {
                            Text("Delete")
                        }
                    }
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

            if thought.emotionExists {
                ThoughtCardAttrbuteView(
                    icon: Image(thought.emotion!.getIcon()),
                    text: thought.emotion!.rawValue.capitalized,
                    backgroundColor: thought.emotion!.getColor(),
                    foregroundColor: .black.opacity(0.6),
                    shadowColor: thought.emotion!.getColor()
                )
            }

            // Toolbar !
            ToolbarView(
                thought: thought,
                showEmotionModal: $modalManager.emotionSelect
            )
            .padding(.vertical, 20)

            Spacer()
        }
        .sheet(isPresented: $modalManager.emotionSelect) {
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
        .onChange(of: thought.photos) {
            DispatchQueue.main.async {
                if thought.photos.isEmpty {
                    withAnimation {
                        self.photo = nil
                    }

                    return
                }

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

                    //                    Have to reset DeepLinkViewModel everytime you add or cancel or else future thoughts will have dlvm's previous residue
                    deeplinkManager.reset()
                    dismiss()
                }
            }

            ToolbarItem {
                Button(confirmationText) {
                    handleSubmit()

                    //  Have to reset DeepLinkViewModel everytime you add or cancel or else future thoughts will have dlvm's previous residue
                    deeplinkManager.reset()
                }.disabled(isSubmittingDisabled)
            }
        }
        .onAppear {
            // Set the originalThought to be the Thought passed through
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
            focusedField = .response
            thoughtVm.context = context
        }
    }
}

extension ThoughtDetailForm {
    func handleCancel() {
        //        The reason we check if its not editMode and init the original thought is so that when the user cancels, it will set it to its' default new Thought values
        if !editMode {
            originalThought = .init()
        }

        print("Cancelling thought add/edit – Setting back to original thought")

        thought.thought_prompt = originalThought.thought_prompt
        thought.thought_response = originalThought.thought_response
        thought.emotion = originalThought.emotion
        thought.photos = originalThought.photos
        thought.music = originalThought.music
        thought.location = originalThought.location
    }

    func handleSubmit() {
        print("Adding/saving new thought")
        thoughtVm.insert(thought)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        ThoughtDetailForm(thought: .init(thought_prompt: "What do you think about fans?", thought_response: "", date_created: Date.now))
    }
}
