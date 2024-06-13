//
//  ThoughtView.swift
//  thoughtful
//
//  Created by Nabil Ridhwan on 13/6/24.
//

import SwiftUI

struct ThoughtView: View {
    
    let thought: Thought;
    
    var body: some View {
        Button {
            print("Clicked on \(thought.thought_response)")
        } label: {
            
        VStack(alignment: .leading, spacing: 5){
            Text(thought.thought_prompt)
                .opacity(0.5)
                .fontWeight(.bold)
                .font(.callout)
            Text(thought.thought_response)
                .font(.callout)

            HStack{
                
                if (thought.location != nil) {
                    ThoughtAttributeView(icon: "location.fill", text: "Eunos")
                }
                
                if (thought.music != nil) {
                    ThoughtAttributeView(icon: "music.note", text: "The Backseat Lovers - Pool House")
                }
                
                if (thought.emotion != nil) {
                    ThoughtAttributeView(icon: "smiley.fill", text: "Happy", backgroundColor: .yellow, foregroundColor: .black.opacity(0.6), shadowColor: .yellow)
                }
                
                
                
            }
        }
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(.white)
        .padding()
        .background{
                RoundedRectangle(cornerRadius: 24)
                .foregroundStyle(.card)
        }
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 24)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        )
        }
    }
}

#Preview {
    ThoughtView(thought: Thought(thought_prompt: "What are three things that I am grateful for?", thought_response: "My Friends, Nazrul for checking up on me, The movie night on Discord", date_created: Date.now, location: "Eunos", music: "The Backseat Lovers - Pool House", emotion: "Neutral"))

}
