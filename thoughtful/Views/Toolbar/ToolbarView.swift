//
//  ToolbarView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 15/6/24.
//

import PhotosUI
import SwiftUI

struct ToolbarView: View {
    @ObservedObject var thought: Thought
    @StateObject var sound: AudioRecordPlayback = .init()
    @Binding var showEmotionModal: Bool

    @State var showPhotosPicker: Bool = false
    @State var photosPickerItem: PhotosPickerItem?

    let addEmotionTip = AddEmotionTip()

    var emotionExists: Bool {
        thought.emotionExists
    }

    var body: some View {
        HStack {
            //            Button {
            //                print("Location")
            //            } label: {
            //                Label("Location", systemImage: "location.fill")
            //                    .labelStyle(.iconOnly)
            //            }
            //            .frame(maxWidth: .infinity)

            //            Button{
            //                print("Music")
            //            }   label: {
            //                Label("Music", systemImage: "music.note")
            //                    .labelStyle(.iconOnly)
            //            }
            //            .frame(maxWidth: .infinity)

            Button {
                withAnimation {
                    showEmotionModal = true
                }
                addEmotionTip.invalidate(reason: .actionPerformed)
            } label: {
                Label("Emotion", systemImage: "face.smiling")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.primary.opacity(emotionExists ? 1.0 : 0.5))
            }
            .frame(maxWidth: .infinity)
            .popoverTip(addEmotionTip)

            Button {
                print("Record Audio")
                sound.toggleRecording()
            } label: {
                Label("Record Audio", systemImage: sound.isRecording ? "mic.fill" : "mic")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(sound.isRecording ? .red : .primary)
            }
            .frame(maxWidth: .infinity)

            Button {
                let url = sound.filePath
                sound.playAudioFromURL(url!)

            } label: {
                Label("Play/Stp", systemImage: sound.isPlaying ? "stop.fill" : "play.fill")
                    .labelStyle(.iconOnly)
            }
            .disabled(sound.filePath == nil)
            .frame(maxWidth: .infinity)

            PhotosPicker(selection: $photosPickerItem, matching: .images) {
                Label("Open Photos", systemImage: "photo.fill")
                    .labelStyle(.iconOnly)
            }
            .frame(maxWidth: .infinity)
        }
        .onChange(of: sound.isRecording) { _, newValue in
            if newValue == false {
                thought.audioFileName = sound.fileName
            }
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(.primary.opacity(0.5))
        .onChange(of: photosPickerItem) { _, newValue in
            Task {
                // Check if newValue is optional, and if it isnt, load transferrable as Data.self
                if let newValue,
                   let data = try? await newValue.loadTransferable(type: Data.self),
                   let image = UIImage(data: data)?.jpegData(compressionQuality: 0.1)
                {
                    thought.photos = [image]
                }
            }
        }
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

#Preview {
    ToolbarView(thought: Thought(thought_prompt: "", thought_response: "", date_created: Date.now), showEmotionModal: .constant(false))
        .background(Color.background)
        .environmentObject(ModalManager())
}
