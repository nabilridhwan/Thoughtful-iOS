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
            VStack(alignment: .center) {
                Text("Transcript")
                    .frame(maxWidth: .infinity)
                    .font(.caption2)
                    .foregroundStyle(.primary.opacity(0.5))

                Text(t)

//                Button("Set as response"){
//                    print(t)
//                }
//                .buttonStyle(.borderedProminent)
//                .frame(width: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.cardAttribute)
//            .background(.primary.opacity(0.1), in: RoundedRectangle(cornerRadius: 24))
        }
    }
}

#Preview {
    AudioTranscriptionView(transcript: "Hello there but what in the world is happening right here? Why is this not working")
}
