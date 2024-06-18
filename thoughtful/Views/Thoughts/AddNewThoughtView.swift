//
//  AddNewThoughtView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 15/6/24.
//

import SwiftUI

struct AddNewThoughtView: View {
    @Binding var thought: Thought
    @Binding var date: Date

    @Environment(\.dismiss) var dismiss;
    //    Model Context for Thoughts (SwiftData)
    @Environment(\.modelContext) var modelContext;

    //    @State var showPromptModal: Bool = false
    @State var showEmotionModal: Bool = false

    //    For handling what 'Next' button does, check out the binding with the TextField and also the onSubmit
    @FocusState private var focusedField: Field?

    var isSubmittingDisabled: Bool {
        thought.thought_prompt.isEmpty || thought.thought_response.isEmpty
    }

    @State var photo: UIImage?

    var body: some View {
        VStack(alignment: .leading) {
            if photo != nil {
                Image(uiImage: photo!)
                    .resizable()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Form
            VStack(alignment: .leading) {
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
            }
            //            .sheet(isPresented: $showPromptModal) {
            //                ZStack {
            //                    Color.background.ignoresSafeArea()
            //                    ChoosePromptView(prompt: $prompt)
            //                        .padding()
            //                        .presentationDetents([.medium])
            //                }.ignoresSafeArea(edges: .bottom)
            //            }
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

            if thought.emotion != nil {
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
                thought: $thought,
                showEmotionModal: $showEmotionModal,
                focusedField: _focusedField
            )
            .padding(.vertical, 20)

            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }

            ToolbarItem {
                Button("Add") {
                    handleAdd()
                }.disabled(isSubmittingDisabled)
            }
        }
        .onChange(of: thought.photos) { _, newValue in
            if !newValue.isEmpty {
                DispatchQueue.global().async {
                    if let loadedPhoto = UIImage(data: newValue[0]) {
                        DispatchQueue.main.async {
                            withAnimation {
                                self.photo = loadedPhoto
                            }
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
    func handleAdd() {
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
        AddNewThoughtView(thought: .constant(.init()), date: .constant(Date.now))
    }
}
