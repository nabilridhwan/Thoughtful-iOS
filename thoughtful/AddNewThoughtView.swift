//
//  AddNewThoughtView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 15/6/24.
//

import SwiftUI

struct AddNewThoughtView: View {
    @Environment(\.dismiss) var dismiss;
    //    Model Context for Thoughts (SwiftData)
    @Environment(\.modelContext) var modelContext;
    
    //    Form fields
    @State private var prompt: String = "";
    @State private var response: String = "";
    @State var emotion: Emotion?
    
    @State var showPromptModal: Bool = false;
    @State var showEmotionModal: Bool = false;

    //    For handling what 'Next' button does, check out the binding with the TextField and also the onSubmit
    @FocusState private var focusedField: Field?;
    
    var isSubmittingDisabled : Bool {
        prompt.isEmpty || response.isEmpty
    }
    
    var body: some View {
        VStack{
            // Form
            VStack{
                HStack{
                    TextField("Type your prompt here...", text: $prompt)
                        .submitLabel(.next)
                        .lineLimit(2)
                    
                    if !prompt.isEmpty {
                        Button{
                            prompt = ""
                        }label: {
                            Label("Select", systemImage: "multiply.circle.fill").labelStyle(.iconOnly)
                        }
                    }else{
                        Button{
                            showPromptModal = true
                        } label: {
                             Label("Select", systemImage: "wand.and.stars").labelStyle(.iconOnly)
                        }
                    }
                }
                .foregroundStyle(.white.opacity(0.5))
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.cardAttribute)
                }
                
                TextField("Type your reply...", text: $response, axis: .vertical)
                    .submitLabel(.done)
                    .lineLimit(4, reservesSpace: true)
                    .focused($focusedField, equals: .response)
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.cardAttribute)
                    }
                
                //                    Button(action: {
                //                        print("Hello world")
                //                    }) {
                //                        Label("Add", systemImage: "plus")
                //                            .padding(12)
                //                            .foregroundColor(.black)
                //                            .frame(maxWidth: .infinity)
                //                            .background(.accent,
                //                                        in: RoundedRectangle(cornerRadius: 24))
                //                    }
            }
            
            .sheet(isPresented: $showPromptModal){
                ZStack{
                    Color.background.ignoresSafeArea()
                    ChoosePromptView(prompt: $prompt)
                    .padding()
                    .presentationDetents([.medium])
                }.ignoresSafeArea(edges: .bottom)
            }
            .sheet(isPresented: $showEmotionModal){
                ZStack{
                    Color.background.ignoresSafeArea()
                    ChooseEmotionView(
                        emotion: $emotion
                    )
                    .padding()
                    .presentationDetents([.medium])
                }.ignoresSafeArea(edges: .bottom)
            }
            
            // Toolbar !
            ToolbarView(
                emotion: $emotion,
                showEmotionModal: $showEmotionModal,
                focusedField: _focusedField,
                prompt: $prompt
            )
            .padding(.vertical, 20)
            
            Spacer()
        }
        .padding()
        .toolbar{
            
            ToolbarItem(placement: .topBarLeading){
                Button("Cancel"){
                    dismiss()
                }
            }
            
            ToolbarItem{
                Button("Add"){
                    handleAdd()
                }.disabled(isSubmittingDisabled)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
        .background(Color.background)
        
    }
}

extension AddNewThoughtView {
    func handleAdd(){
        let newThought = Thought(thought_prompt: prompt.localizedCapitalized, thought_response: response.localizedCapitalized, date_created:Date.now)
        
        if emotion != nil {
            newThought.emotion = emotion
        }
        
        modelContext.insert(newThought)
        
        dismiss()
        
    }
}

#Preview {
    NavigationStack{
        AddNewThoughtView()
    }
}
