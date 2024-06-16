//
//  HomeView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 16/6/24.
//

import SwiftUI
import SwiftData

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
                    Label("Add Thought", systemImage: "plus")
                        .labelStyle(.iconOnly)
                }
            }
            
            //            Text(filteredDate.formatted(.relative(presentation: .named)))
            
            HorizontalCalendarView(selectedDate: $filteredDate)
                .padding(.vertical, 10)
            
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
                isPresented = true
            }
            print("Received deeplink \(url) \(url.lastPathComponent)")
        }
        
        
    }
}

#Preview {
    HomeView()
        .modelContainer(SampleData.shared.modelContainer)
}
