//
//  ThoughtDetailView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 15/6/24.
//

import AVFAudio
import SwiftUI

struct ThoughtDetailView: View {
    @State var thoughtVm: ThoughtViewModel = .init()

    @StateObject private var player: AudioPlayer = .init()
    @State private var timeRemaining: TimeInterval = 0

    @ObservedObject var thought: Thought
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    @EnvironmentObject var modalManager: ModalManager

    @State var audioSession: AVAudioSession?
    @State var audioPlayer: AVAudioPlayer?

    var relativeDateCreated: String {
        thought.date_created.formatted(.relative(presentation: .named)).capitalized
    }

    @State var photo: UIImage? = nil

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
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if photo != nil {
                    Image(uiImage: photo!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .transition(
                            .scale.combined(with: .opacity)
                        )
                }

                Text(thought.thought_prompt)
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(LocalizedStringKey(thought.thought_response))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Divider()

                //            https://developer.apple.com/documentation/foundation/date/relativeformatstyle

                if thought.audioFileName != nil {
                    Text("Audio")
                        .font(.caption2)
                        .foregroundStyle(.primary.opacity(0.5))

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
                        .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 24))

                        Spacer()

                        Text(formatTime(timeRemaining))
                            .font(.caption)
                    }
                }

                if thought.emotionExists {
                    Text("Emotion")
                        .font(.caption2)
                        .foregroundStyle(.primary.opacity(0.5))
                    ThoughtCardAttrbuteView(icon: Image(thought.emotion!.getIcon()), text: thought.emotion!.rawValue.capitalized, backgroundColor: thought.emotion!.getColor(), foregroundColor: .black.opacity(0.6), shadowColor: thought.emotion!.getColor())
                } else {
                    Text("How were you feeling?")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    HStack {
                        ForEach(Emotion.allCases, id: \.self) {
                            e in

                            Button {
                                withAnimation {
                                    thought.emotion = e
                                }
                            } label: {
                                VStack {
                                    Image(e.getIcon())
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(e.getColor())
                                }
                            }
                            .padding()
                            .background(e.getColor(), in: RoundedRectangle(cornerRadius: 14)
                                .stroke(lineWidth: 2))
                        }
                    }
                }

                Text("Created")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Label(relativeDateCreated, systemImage: "clock")
                    .foregroundStyle(.secondary.opacity(0.7))
                    .font(.caption)
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .foregroundStyle(.primary)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") {
                    modalManager.edit = true
                }
            }

            ToolbarItem(placement: .primaryAction) {
                Button("Delete", role: .destructive) {
                    modalManager.confirmDelete = true

                }.foregroundStyle(.red)
            }
        }
        .onAppear {
            thoughtVm.context = context
        }
        .onAppear {
            if let duration = thought.audioDuration {
                timeRemaining = duration
            }
        }
        .task {
            DispatchQueue.global(qos: .background).async {
                guard let photo = thought.photo else {
                    return
                }

                let loadedPhoto = UIImage(data: photo)

                withAnimation {
                    self.photo = loadedPhoto
                }
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
        .onChange(of: thought.photos) { _, photos in
            DispatchQueue.global(qos: .background).async {
                if photos.isEmpty {
                    withAnimation {
                        self.photo = nil
                    }
                    return
                }

                guard let photo = thought.photo else {
                    return
                }

                let loadedPhoto = UIImage(data: photo)

                withAnimation {
                    self.photo = loadedPhoto
                }
            }
        }
        .sheet(isPresented: $modalManager.edit) {
            NavigationStack {
                ThoughtDetailForm(
                    thought: thought,
                    editMode: true
                )
            }
            .interactiveDismissDisabled()
        }
        .confirmationDialog("Are you sure?", isPresented: $modalManager.confirmDelete) {
            Button("Delete", role: .destructive) {
                dismiss()
                thoughtVm.delete(thought)
            }
        } message: {
            Text("Are you sure? You cannot undo this action")
        }
    }
}

// extension ThoughtDetailView: AVAudioPlayerDelegate {
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        isPlaying = false
//    }
// }

#Preview {
    NavigationStack {
        ThoughtDetailView(thought: SampleData.shared.thought)
    }
    .environmentObject(ModalManager())
    .modelContext(SampleData.shared.context)
    .modelContainer(SampleData.shared.modelContainer)
}

#Preview {
    NavigationStack {
        ThoughtDetailView(thought: .init(thought_prompt: "Prompt", thought_response: "Response", date_created: Date.now))
    }
    .environmentObject(ModalManager())
    .modelContext(SampleData.shared.context)
    .modelContainer(SampleData.shared.modelContainer)
}
