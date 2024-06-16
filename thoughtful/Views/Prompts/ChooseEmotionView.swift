//
//  ChooseEmotionView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 15/6/24.
//

import SwiftUI

struct ChooseEmotionView: View {
    
    @Binding var emotion: Emotion?;
    @Environment(\.dismiss) var dismiss;
    
    func handleAddEmotion(_ e: Emotion){
        
        //        If the incoming emotion is the same as the emotion selected, then it means the user is trying to deselect, hence set emotion to nil
        if(emotion == e){
            emotion = nil;
            return;
        }
        //        set the emotion 'binding' to the value passed
        emotion = e
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Choose an Emotion")
                .font(.title)
                .bold()
            
            ScrollView{
                ForEach(Emotion.allCases, id: \.self){
                    e in
                    Button{
                        handleAddEmotion(e)
                        dismiss()
                    }label: {
                        if e == emotion {
                            Label(e.description.capitalized, systemImage: "checkmark")
                        }else{
                            Text(e.description.capitalized)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black.opacity(0.7))
                    .background(emotionColors[e]!, in: RoundedRectangle(cornerRadius: 24))
                }
            }
            
        }.frame(maxWidth: .infinity)
    }
    
}

//#Preview {
//    ChooseEmotionView()
//}
