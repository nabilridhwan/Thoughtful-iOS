//
//  ThoughtDetailView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 15/6/24.
//

import SwiftUI

struct ThoughtDetailView: View {
    @Bindable var thought: Thought;
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    //    State for showing the confirm delete option
    @State var isPresentingConfirm: Bool = false
    
    var emotionExists: Bool {
        thought.emotion != nil
    }
    
    var relativeDateCreated: String {
        thought.date_created.formatted(.relative(presentation: .named)).capitalized
    }
    
    var body: some View {
        ScrollView{
            
            
            VStack(alignment: .leading, spacing: 10){
                Text(thought.thought_prompt)
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(LocalizedStringKey(thought.thought_response))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                //            https://developer.apple.com/documentation/foundation/date/relativeformatstyle
                
                if (emotionExists) {
                    Text("Emotion")
                        .font(.caption2)
                        .foregroundStyle(.primary.opacity(0.5))
                    
                    ThoughtCardAttrbuteView(icon: "smiley.fill", text: thought.emotion!.description.capitalized, backgroundColor: emotionColors[thought.emotion!], foregroundColor: .black.opacity(0.6), shadowColor: emotionColors[thought.emotion!])
                }
                
                Text("Created")
                    .font(.caption2)
                    .foregroundStyle(.primary.opacity(0.5))
                Label(relativeDateCreated, systemImage: "clock")
                    .foregroundStyle(.primary.opacity(0.6))
                    .font(.caption)
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .foregroundStyle(.primary)
        .toolbar{
            ToolbarItem(placement: .primaryAction){
                Button("Delete"){
                    isPresentingConfirm = true
                    
                }.foregroundStyle(.red)
            }
        }
        .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm){
            Button("Delete", role: .destructive) {
                dismiss()
                context.delete(thought)
            }
        } message: {
            Text("Are you sure? You cannot undo this action")
        }
        
    }
}

#Preview {
    NavigationStack{
        ThoughtDetailView(thought: SampleData.shared.thought)
    }
    .modelContext(SampleData.shared.context)
    .modelContainer(SampleData.shared.modelContainer)
}
