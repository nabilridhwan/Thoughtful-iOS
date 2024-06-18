//
//  AddNewThoughtView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 15/6/24.
//

import SwiftUI

struct AddNewThoughtView: View {
    @Binding var prompt: String
    @Binding var date: Date

    @Environment(\.dismiss) var dismiss;
    //    Model Context for Thoughts (SwiftData)
    @Environment(\.modelContext) var modelContext;

    @State var newThought: Thought = .init(thought_prompt: "", thought_response: "", date_created: Date.now)

    //    Form fields
    @State private var response: String = ""
    @State var emotion: Emotion?

    //    @State var showPromptModal: Bool = false
    @State var showEmotionModal: Bool = false

    //    For handling what 'Next' button does, check out the binding with the TextField and also the onSubmit
    @FocusState private var focusedField: Field?

    var isSubmittingDisabled: Bool {
        prompt.isEmpty || response.isEmpty
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Form
            VStack(alignment: .leading) {
                Text(prompt)
                    .font(.title3)
                    .bold()
                TextField("Type your reply...", text: $response, axis: .vertical)
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
                        emotion: $emotion
                    )
                    .padding()
                    .presentationDetents([.medium])
                }.ignoresSafeArea(edges: .bottom)
            }

            if !newThought.photos.isEmpty {
                Image(uiImage: UIImage(data: newThought.photos[0])!)
                    .resizable()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }

            if emotion != nil {
                ThoughtCardAttrbuteView(icon: Image(emotion!.getIcon()), text: emotion!.description.capitalized, backgroundColor: emotion!.getColor(), foregroundColor: .black.opacity(0.6), shadowColor: emotion!.getColor())
            }

            // Toolbar !
            ToolbarView(
                thought: $newThought,
                showEmotionModal: $showEmotionModal,
                focusedField: _focusedField,
                prompt: $prompt
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
        newThought.thought_prompt = prompt
        newThought.date_created = date
        newThought.thought_response = response

        if emotion != nil {
            newThought.emotion = emotion
        }

        modelContext.insert(newThought)

        dismiss()
    }
}

// #Preview {
//    NavigationStack{
//
//        AddNewThoughtView(date: $filteredDate)
//    }
//
// }
