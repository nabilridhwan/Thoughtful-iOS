//
//  ContentView.swift
//  thoughtful
//
//  Created by Nabil Ridhwan on 13/6/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    enum Field {
        case prompt;
        case response;
    }
    
    @State private var prompt: String = "";
    @State private var response: String = "";
    @State private var sample_thoughts: [Thought] = []
    
//    Bases on focusedField in onChange to have animations
    @State private var isFormActive: Bool = false;
    
    //    For handling what 'Next' button does, check out the binding with the TextField and also the onSubmit
    @FocusState private var focusedField: Field?;
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Home")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.largeTitle)
            
            HorizontalCalendarView()
                .padding(.vertical, 10)
            
            if(sample_thoughts.isEmpty){
                NoThoughtsView()
                    .padding(.horizontal, 40)
                    .padding(.top, 80)
            }
            
            if(!sample_thoughts.isEmpty){
                ScrollView{
                    ForEach(sample_thoughts, id: \.thought_response) {
                        thought in
                        ThoughtView(thought: thought)
                    }
                }
                .scrollDismissesKeyboard(.interactively)
            }
            
            Spacer()
            
            
            VStack{
                
                //                Show toolbar when text field is active
                if(isFormActive){
                    HStack{
                        Button{
                            print("Location")
                        }   label: {
                            Label("Location", systemImage: "location.fill")
                                .labelStyle(.iconOnly)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button{
                            print("Music")
                        }   label: {
                            Label("Music", systemImage: "music.note")
                                .labelStyle(.iconOnly)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button{
                            print("Emotion")
                        }   label: {
                            Label("Emotion", systemImage: "face.smiling")
                                .labelStyle(.iconOnly)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button{
                            print("Open Camera")
                        }   label: {
                            Label("Open Camera", systemImage: "camera.fill")
                                .labelStyle(.iconOnly)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button{
                            print("Open Photos")
                        }   label: {
                            Label("Open Photos", systemImage: "photo.fill")
                                .labelStyle(.iconOnly)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                        .animation(.easeInOut, value: isFormActive)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white.opacity(0.5))
                    
                    Divider()
                        .padding(.vertical, 3)
                }
                
                
                //                Form
                HStack{
                    VStack(spacing: 10){
                        TextField("Write your prompt here", text: $prompt)
                            .focused($focusedField, equals: .prompt)
                            .submitLabel(.next)
                            .foregroundStyle(.white.opacity(0.5))
                        
                        if(isFormActive){
                            TextField("Write your thoughts here", text: $response, axis: .vertical)
                                .submitLabel(.done)
                                .lineLimit(8)
                                .focused($focusedField, equals: .response)
                        }
                    }
                    .onSubmit{
                        switch focusedField {
                        case .prompt:
                            focusedField = .response
                        case .response:
                            focusedField = nil
                            handleSubmit()
                        default:
                            print("Creating account…")
                        }
                    }
                    
                    Button{
                        handleSubmit()
                    } label: {
                        Label("Add", systemImage: "plus").labelStyle(.iconOnly)
                    }.disabled(response.isEmpty || prompt.isEmpty)
                    
                }
            }
            .padding()
            .background{
                RoundedRectangle(cornerRadius: 24)
                    .padding(5)
                    .foregroundStyle(.cardAttribute)
                    .overlay{
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                            .padding(5)
                        
                    }
            }
            
        }
        .onChange(of: isFormActive, { oldValue, newValue in
            print("isFormActive changed \(isFormActive)")
        })
        .onChange(of: focusedField, { oldValue, newValue in
            withAnimation(.easeOut(duration: 0.3)){
                if(newValue == nil){
                    isFormActive = false
                }else{
                    isFormActive = true
                }
            }
            print("focusedField changed:")
            print(newValue != nil ? newValue! : "nil")
        })
        .padding()
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

// MARK: Helper Function Declarations
extension ContentView {
    func clearInputs(){
        prompt = "";
        response = "";
    }
    
    func handleSubmit(){
        if(prompt.isEmpty || response.isEmpty){
            return
        }
        
        let newThought = Thought(thought_prompt: prompt, thought_response: response, date_created: Date.now)
        
        clearInputs()
        
        withAnimation(.easeOut){
            focusedField = nil
            sample_thoughts.append(newThought)
        }
        
        
    }
}

#Preview {
    ContentView()
}
