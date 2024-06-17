//
//  ChoosePromptView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 15/6/24.
//

import SwiftUI
import TipKit

struct ChoosePromptView: View {
    
    @State var date: Date = Date.now
    @State var currentTab: String = "choose_prompt"
    @State var showAddNewThoughtView: Bool = false
    @State var showCustomPrompt: Bool = false
    @Binding var prompt: String;
    @Environment(\.dismiss) var dismiss;
    
    var addCustomPromptTip = AddCustomPromptTip()
    
    func handlePressPrompt(_ p: String){
        withAnimation{
            prompt = p
            //        showAddNewThoughtView = true
            currentTab = "add_thought"
            
        }
    }
    
    var body: some View {
        TabView(selection: $currentTab){
            VStack(alignment: .leading){
                Text("Choose a prompt")
                    .font(.title)
                    .bold()
                
                ScrollView{
                    
                    Button {
                        showCustomPrompt = true
                        addCustomPromptTip.invalidate(reason: .actionPerformed)
                        prompt = ""
                    } label: {
                        Text("Custom Prompt")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.cardAttribute, in: RoundedRectangle(cornerRadius: 24))
                    .popoverTip(addCustomPromptTip)
                    
                    ForEach(gratitudeQuestions, id: \.self){ p in
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
            
            
            AddNewThoughtView(
                prompt: $prompt,
                date: $date
            )
            .tag("add_thought")
            
        }
        .alert("Add Custom Prompt", isPresented: $showCustomPrompt){
            Button("Cancel", role: .cancel) {}
            Button("OK") {
                handlePressPrompt(prompt)
            }
            
            TextField("Type your custom prompt", text: $prompt)
                .lineLimit(3, reservesSpace: true)
        }
        .sheet(isPresented: $showAddNewThoughtView){
            NavigationStack{
                AddNewThoughtView(
                    prompt: $prompt,
                    date: $date
                )
            }
            .presentationDetents([.medium])
        }
        .ignoresSafeArea(edges: .bottom)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.primary)
        .background(Color.background)
        .tabViewStyle(.page(indexDisplayMode: .never))
        
    }
}

//#Preview {
//    ChoosePromptView()
//}
