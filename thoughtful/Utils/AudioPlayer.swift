//
//  AudioPlayer.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 24/6/24.
//

import AVFAudio
import Foundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var audioSession: AVAudioSession
    private var audioPlayer: AVAudioPlayer?

    private var filePath: URL?
    private var fileDuration: TimeInterval = 0

    var isPlaying: Bool {
        audioPlayer != nil && audioPlayer!.isPlaying
    }

    override init() {
        audioSession = AVAudioSession.sharedInstance()
        super.init()
        configureAudioSession()
    }

    func play(_ url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()

            DispatchQueue.main.async {
                if let duration = self.audioPlayer?.duration {
                    self.fileDuration = duration
                }

                self.objectWillChange.send()
            }
        } catch {
            fatalError("Cant load file: \(error.localizedDescription)")
            // couldn't load file :(
        }
    }

    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil

        DispatchQueue.main.async {
            if let duration = self.audioPlayer?.duration {
                self.fileDuration = duration
            }

            self.objectWillChange.send()
        }
    }

    func duration(_ url: URL) -> TimeInterval {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)

            if let duration = audioPlayer?.duration {
                fileDuration = duration

                return duration
            }
        } catch {
            fatalError("Cant load file: \(error.localizedDescription)")
            // couldn't load file :(
        }

        return -1
    }

    private func configureAudioSession() {
        // Retrieve the shared audio session.
        do {
            // Set the audio session category and mode.
            // https://stackoverflow.com/a/65139199
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setMode(.videoRecording)
        } catch {
            print("Failed to set the audio session configuration")
            fatalError("Failed to set the audio session configuration")
        }
    }

    //    For delegate
    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
        audioPlayer = nil
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

// extension AudioPlayer: AVAudioPlayerDelegate {
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully _: Bool) {
//        audioPlayer = nil
//        DispatchQueue.main.async {
//            self.objectWillChange.send()
//        }
//        print("Finished playing: \(player.isPlaying)")
//    }
// }
