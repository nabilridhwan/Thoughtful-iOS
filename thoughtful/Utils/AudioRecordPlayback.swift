//
//  AudioRecordPlayback.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 24/6/24.
//

import AVFAudio
import Foundation

struct PlayableAudio {
    var path: URL
    var isPlayable: Bool = false
    var duration: TimeInterval?
    var currentTime: TimeInterval?

    var audioPlayer: AVAudioPlayer

    init(path: URL, audioPlayer: AVAudioPlayer) {
        self.path = path
        self.audioPlayer = audioPlayer
    }
}

typealias AudioRecordingSession = [PlayableAudio]

class AudioRecordPlayback: NSObject, ObservableObject {
    private var audioSession: AVAudioSession
    private var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?

    var filePath: URL?
    var fileName: String?
    var fileDuration: TimeInterval?

    var isRecording: Bool {
        audioRecorder != nil && audioRecorder!.isRecording
    }

    var isPlaying: Bool {
        audioPlayer != nil && audioPlayer!.isPlaying
    }

    override init() {
        audioSession = AVAudioSession.sharedInstance()
        super.init()
        configureAudioSession()
    }

    func toggleRecording() {
        // Why we use threading is to allow the computed properties above (isRecording) to change immediately: https://chatgpt.com/share/db837e65-16ff-428d-a5b5-2e8f56204312

        if audioRecorder != nil {
            stopRecord()

            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
            return
        }

        DispatchQueue.global(qos: .background).async {
            self.startRecord()

            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }

    func playAudioFromURL(_ url: URL) {
        if audioPlayer != nil {
            stopPlaying()

            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()

            fileDuration = audioPlayer?.duration

            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        } catch {
            fatalError("Cant load file: \(error.localizedDescription)")
            // couldn't load file :(
        }
    }

    func stopPlaying() {
        audioPlayer?.stop()
        audioPlayer = nil
        fileDuration = audioPlayer?.duration
    }

    static func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    private func startRecord() {
        let audioSettings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
        ]

        let fileName = "recording-\(UUID().uuidString).m4a"
        let audioFilepath = AudioRecordPlayback.getFileURL().appendingPathComponent(fileName)
        filePath = audioFilepath
        self.fileName = fileName

        do {
            print("Recording Audio")
            audioRecorder = try AVAudioRecorder(url: audioFilepath, settings: audioSettings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            print(error)
            fatalError(error.localizedDescription)
        }
    }

    private func stopRecord() {
        print("Stopping recording")
        audioRecorder?.stop()
        audioRecorder = nil
        fileDuration = audioPlayer?.duration
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
}

extension AudioRecordPlayback: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_: AVAudioRecorder, successfully flag: Bool) {
        print("Finished recording: \(flag)")
        if flag {
            playAudioFromURL(filePath!)
        }
    }
}

extension AudioRecordPlayback: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully _: Bool) {
        audioPlayer = nil
        print("Finished playing: \(player.isPlaying)")
    }
}
