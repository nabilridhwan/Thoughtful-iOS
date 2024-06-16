//
//  ContentView.swift
//  thoughtful
//
//  Created by Nabil Ridhwan on 13/6/24.
//

import SwiftUI
import SwiftData

enum Field {
    case prompt;
    case response;
}

let gratitudeQuestions = [
    "What are three things you are grateful for today?",
    "Who is someone you feel especially grateful to have in your life? Why?",
    "What is a recent experience that made you feel grateful?",
    "What is something you are grateful for that you usually take for granted?",
    "What is a personal quality or ability you are grateful for?",
    "What is a place you feel grateful for and why?",
    "What is a challenge you faced that you are now grateful for?",
    "What is something beautiful you saw recently that you are thankful for?",
    "What are you grateful for in your current job or daily routine?",
    "What technology or modern convenience are you grateful for?"
]

struct ContentView: View {
    
    @Environment(\.modelContext) private var context: ModelContext;
    @Query(sort: \Thought.date_created, order: .reverse) private var thoughts: [Thought]
    
    @State var filteredDate: Date = Date.now;
    
    //    Present modal on pressing "Add Thought"
    @State var isPresented = false
    
    @State private var newThought: Thought?
    
    @State private var prompt: String = "";
    @State private var response: String = "";
    
    //    Bases on focusedField in onChange to have animations
    @State private var isFormActive: Bool = false;
    
    //    For handling what 'Next' button does, check out the binding with the TextField and also the onSubmit
    @FocusState private var focusedField: Field?;
    
    @State var emotion: Emotion?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                HStack{
                    Text("Home")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                    Spacer()
                    
                    Button{
                        withAnimation{
                            isPresented.toggle()
                        }
                    }label: {
                        Label("Add Thought", systemImage: "plus.circle")
                    }
                }
                
                //                Text(filteredDate.formatted(.relative(presentation: .named)))
                
                //                HorizontalCalendarView(selectedDate: $filteredDate)
                //                    .padding(.vertical, 10)
                
                ScrollView{
                    if(thoughts.isEmpty){
                        VStack{
                            EmptyThoughtsView()
                                .padding(.horizontal, 40)
                                .padding(.top, 80)
                                .padding(.bottom, 20)
                        }
                    }else{
                        ForEach(thoughts){ thought in
                            NavigationLink{
                                ThoughtDetailView(thought: thought)
                            }label:{
                                ThoughtView(thought: thought)
                            }
                            
                        }
                        
                    }
                }
                .scrollDismissesKeyboard(.interactively)
                
                Spacer()
            }
            //            .toolbar{
            //                ToolbarItem(placement: .confirmationAction){
            //                    Button("Add"){
            //                        print("Add pressed")
            //                    }
            //                }
            //            }
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
            .ignoresSafeArea(.all, edges: .bottom)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(isPresented: $isPresented){
                NavigationStack{
                    
                    ZStack {
                        Color.background.edgesIgnoringSafeArea(.all)
                        AddNewThoughtView()
                    }
                    
                }
                .presentationDetents([.medium])
            }
            .foregroundStyle(.white)
            .background(Color.background)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}
