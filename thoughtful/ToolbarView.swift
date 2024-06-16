//
//  ToolbarView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 15/6/24.
//

import SwiftUI

struct ToolbarView: View {
    @Binding var emotion: Emotion?;
    @Binding var showEmotionModal: Bool;
    @FocusState var focusedField: Field?
    @Binding var prompt: String;
    
    var emotionExists: Bool {
        emotion != nil
    }
    
    var body: some View {
        
        HStack{
            Button{
                print("Location")
            }   label: {
                Label("Location", systemImage: "location.fill")
                    .labelStyle(.iconOnly)
            }
            .frame(maxWidth: .infinity)
            
//            Button{
//                print("Music")
//            }   label: {
//                Label("Music", systemImage: "music.note")
//                    .labelStyle(.iconOnly)
//            }
//            .frame(maxWidth: .infinity)
            
            
            Button {
                withAnimation{
                    showEmotionModal = true
                }
            } label: {
                Label("Emotion", systemImage: "face.smiling")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.white.opacity(emotionExists ? 1.0 : 0.5))
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
        .frame(maxWidth: .infinity)
        .foregroundStyle(.white.opacity(0.5))
    }
}


extension ToolbarView {
//    func handleAddEmotion(_ e: Emotion){
//        
//        //        If the incoming emotion is the same as the emotion selected, then it means the user is trying to deselect, hence set emotion to nil
//        if(emotion == e){
//            emotion = nil;
//            return;
//        }
//        //        set the emotion 'binding' to the value passed
//        emotion = e
//    }
}

//#Preview {
//    ToolbarView()
//        .background(Color.background)
//}
