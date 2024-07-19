//
//  SpeechRecognizer.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 18/7/24.
//

import Foundation
import Speech

// https://medium.com/@kegoaps/audio-file-speech-transcription-using-sfspeechrecognizer-on-swiftui-5be019c81afe

class SpeechRecognizer: ObservableObject {
    @Published var isTranscribing: Bool = false
    @Published var transcript: String = ""

    func requestTranscribe(path: URL) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("You are authorized by user to perform Speech Recognition")
                    self.transcribeFile(url: path) // task 2b
                } else {
                    print("Transcription permission was declined by user")
                }
            }
        }
    }

    // 2b
    func transcribeFile(url: URL) {
        guard let myRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US")) else {
            print("The recognizer is not supported for the current locale")
            return
        }

        if !myRecognizer.isAvailable {
            print("The recognizer is not available right now")
            return
        }
        let path_to_audio = url
        print(path_to_audio)
        let request = SFSpeechURLRecognitionRequest(url: path_to_audio)
        print("About to create recognition task...")

//        Reset states
        transcript = ""
        isTranscribing = true

        myRecognizer.recognitionTask(with: request) { result, error in
            guard let result = result else {
                print("Recognition failed, please check the printed error message")
                print(error!)
                return
            }

            if result.isFinal {
                print(result.bestTranscription.formattedString)
                self.transcript = result.bestTranscription.formattedString
                self.isTranscribing = false
            }
        }
    }
}
