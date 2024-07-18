//
//  AudioTranscriptionView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 18/7/24.
//

import SwiftUI

struct AudioTranscriptionView: View {
    var transcript: String?

    var body: some View {
        if let t = transcript {
            VStack(alignment: .leading) {
                Text("Transcript")
                    .bold()
                    .font(.callout)
                Text(t)

//                Button("Set as response"){
//                    print(t)
//                }
//                .buttonStyle(.borderedProminent)
//                .frame(width: .infinity)
            }
            .padding()
            .background(.primary.opacity(0.1), in: RoundedRectangle(cornerRadius: 24))
        }
    }
}

#Preview {
    AudioTranscriptionView(transcript: "Sample transcription string lies over here!")
}
