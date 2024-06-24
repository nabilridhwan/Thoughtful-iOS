//
//  AudioRecorder.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 24/6/24.
//

import AVFAudio
import Foundation

class AudioRecorder: NSObject, ObservableObject {
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

    static func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    private func startRecord() {
        let audioSettings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
        ]

        let fileName = "recording-\(UUID().uuidString).m4a"
        let audioFilepath = AudioRecorder.getFileURL().appendingPathComponent(fileName)

        // Set the file path and name
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
            try audioSession.setCategory(.record, mode: .default)
        } catch {
            print("Failed to set the audio session configuration")
            fatalError("Failed to set the audio session configuration")
        }
    }
}

extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_: AVAudioRecorder, successfully flag: Bool) {
        print("Finished recording: \(flag)")
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

// extension AudioRecorder: AVAudioPlayerDelegate {
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully _: Bool) {
//        audioPlayer = nil
//        DispatchQueue.main.async {
//            self.objectWillChange.send()
//        }
//        print("Finished playing: \(player.isPlaying)")
//    }
// }
