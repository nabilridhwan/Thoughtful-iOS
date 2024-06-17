//
//  HomeView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 16/6/24.
//

import SwiftUI
import SwiftData
import Charts

enum Field {
    case prompt;
    case response;
}

struct HomeView: View {
    
    @Environment(\.modelContext) private var context: ModelContext;
    @Query(sort: \Thought.date_created, order: .reverse) private var thoughts: [Thought]
    
    @State var filteredThoughts: [Thought] = []
    
    @State var filteredDate: Date = Date.now;
    
    //    Present modal on pressing "Add Thought"
    @State var isAddThoughtPresented = false
    @State var isSettingsPresented = false
    
    @State private var newThought: Thought?
    
    @State private var prompt: String = "";
    @State private var response: String = "";
    
    //    Bases on focusedField in onChange to have animations
    @State private var isFormActive: Bool = false;
    
    //    For handling what 'Next' button does, check out the binding with the TextField and also the onSubmit
    @FocusState private var focusedField: Field?;
    
    @State var emotion: Emotion?
    
    let addThoughtTip = AddThoughtTip()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            //            HStack{
            //                Text("Home")
            //                    .fontWeight(.bold)
            //                    .font(.largeTitle)
            //                Spacer()
            //
            //                Button{
            //                    withAnimation{
            //                        isAddThoughtPresented.toggle()
            //                    }
            //
            //                    addThoughtTip.invalidate(reason: .actionPerformed)
            //
            //                }label: {
            //                    Label("Add Thought", systemImage: "plus")
            //                        .labelStyle(.iconOnly)
            //                }.popoverTip(addThoughtTip)
            //
            //                Button{
            //                    withAnimation{
            //                        isSettingsPresented.toggle()
            //                    }
            //                }label: {
            //                    Label("Settings", systemImage: "person.circle")
            //                        .labelStyle(.iconOnly)
            //                }
            //
            //            }
            //            .foregroundStyle(.white.opacity(0.5))
            
            HorizontalCalendarView(selectedDate: $filteredDate)
                .padding(.vertical, 10)
                .padding(.bottom, 20)
            
            ScrollView{
                if(filteredThoughts.isEmpty){
                    VStack{
                        EmptyThoughtsView()
                            .padding(.horizontal, 40)
                            .padding(.top, 80)
                            .padding(.bottom, 20)
                    }
                }else{
                    ForEach(filteredThoughts){ thought in
                        NavigationLink{
                            ThoughtDetailView(thought: thought)
                        }label:{
                            ThoughtCardView(thought: thought)
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
        .sheet(isPresented: $isAddThoughtPresented){
            NavigationStack{
                ZStack {
                    Color.background.edgesIgnoringSafeArea(.all)
                    ChoosePromptView(
                        prompt: $prompt
                    ).padding()
                    //                    AddNewThoughtView(
                    //                        date: $filteredDate
                    //                    )
                }
                
            }
        }
        
        .sheet(isPresented: $isSettingsPresented){
            NavigationStack{
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
        .navigationTitle("Home")
        .toolbar{
            ToolbarItem{
                
                Button{
                    withAnimation{
                        isAddThoughtPresented.toggle()
                    }
                    
                    addThoughtTip.invalidate(reason: .actionPerformed)
                    
                }label: {
                    Label("Add Thought", systemImage: "plus.circle")
                        .labelStyle(.iconOnly)
                }.popoverTip(addThoughtTip)
            }
            
            ToolbarItem{
                Button{
                    withAnimation{
                        isSettingsPresented.toggle()
                    }
                }label: {
                    Image(systemName: "gear")
                }
            }
        }
        .onAppear{
            // Filter the thoughts
            let filtered = thoughts.filter{
                Calendar.current.compare($0.date_created, to: Date.now, toGranularity: .day) == .orderedSame
            }
            
            withAnimation{
                filteredThoughts = filtered
            }
        }
        
        .onChange(of: thoughts, { oldValue, newValue in
            
            print("Thoughts changed")
            // Filter the thoughts
            let filtered = thoughts.filter{
                Calendar.current.compare($0.date_created, to: filteredDate, toGranularity: .day) == .orderedSame
            }
            
            withAnimation{
                filteredThoughts = filtered
            }
        })
        .onChange(of: filteredDate, { oldValue, newValue in
            
            print("Filtered date changed")
            // Filter the thoughts
            let filtered = thoughts.filter{
                Calendar.current.compare($0.date_created, to: newValue, toGranularity: .day) == .orderedSame
            }
            
            withAnimation{
                filteredThoughts = filtered
            }
        })
        .onOpenURL { url in
#warning("Any deeplink to the app will open the Add Thought modal")
            if url != nil {
                isAddThoughtPresented = true
            }
            print("Received deeplink \(url) \(url.lastPathComponent)")
        }
        
        
    }
}

#Preview {
    NavigationStack{
        HomeView()
            .modelContainer(SampleData.shared.modelContainer)
        
    }
}
