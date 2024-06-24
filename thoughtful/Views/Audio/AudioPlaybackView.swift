//
//  AudioPlaybackView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 24/6/24.
//

import SwiftUI

struct AudioPlaybackView: View {
    @ObservedObject var thought: Thought
    @StateObject var player: AudioPlayer = .init()
    @State private var timeRemaining: TimeInterval = 0

    private func playAudio() {
        guard let fileName = thought.audioFileName else {
            print("No audio")
            return
        }

        let url = AudioRecorder.getFileURL().appendingPathComponent(fileName)

        do {
            let isReachable = try url.checkResourceIsReachable()

            if !isReachable {
                print("URL is not reachable")
                return
            }

            print("URL is reachable: \(isReachable)")

            print("Playing audio: \(url)")
            player.play(url)
        } catch {
            print("Can't play thought audio: \(error)")
        }
    }

    private func stopAudio() {
        player.stop()
    }

    private func startTimer() {
        if let duration = thought.audioDuration {
            timeRemaining = duration
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timer.invalidate()
                }
            }
        }
    }

    private func resetTimer() {
        timeRemaining = 0
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        HStack(alignment: .center) {
            Button {
                if player.isPlaying {
                    stopAudio()
                    return
                }

                playAudio()
            } label: {
                if player.isPlaying {
                    Label("Stop", systemImage: "stop.fill")
                        .labelStyle(.iconOnly)
                } else {
                    Label("Play", systemImage: "play.fill")
                        .labelStyle(.iconOnly)
                }
            }
            .frame(width: 40, height: 40)
            .background(Color.cardAttribute, in: RoundedRectangle(cornerRadius: 24))

            Spacer()

            Text(formatTime(timeRemaining))
                .font(.caption)
        }
        .padding()
        .background(Color.card, in: RoundedRectangle(cornerRadius: 24))
        .onAppear {
            if let duration = thought.audioDuration {
                timeRemaining = duration
            }
        }
        .onChange(of: player.isPlaying) { oldValue, newValue in
            if oldValue == false, newValue == true {
                startTimer()
                return
            }

            if oldValue == true, newValue == false {
                resetTimer()
                return
            }
        }
    }
}

#Preview {
    AudioPlaybackView(thought: SampleData.shared.thought)
}
