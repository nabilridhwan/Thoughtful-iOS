//
//  ChoosePromptView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 15/6/24.
//

import SwiftUI

struct ChoosePromptView: View {
    
    @Binding var prompt: String;
    @Environment(\.dismiss) var dismiss;
    
    func handlePressPrompt(_ p: String){
        prompt = p
        dismiss()
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Choose a prompt")
                .font(.title)
                .bold()
            
            ScrollView{
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
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(.white)
            .background(Color.background)
    }
}

//#Preview {
//    ChoosePromptView()
//}
