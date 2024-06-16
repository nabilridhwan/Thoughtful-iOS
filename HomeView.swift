//
//  HomeView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 16/6/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
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
        NavigationStack{
            
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
    HomeView()
        .modelContainer(SampleData.shared.modelContainer)
}
