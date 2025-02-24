//
//  AudioManager.swift
//  Memory Tiles
//
//  Created by adi on 2/23/25.
//

import AVFoundation
import SwiftUI

class AudioManager: ObservableObject {
    static let shared = AudioManager()

    private var backgroundPlayer: AVAudioPlayer?
    private var sfxPlayer: AVAudioPlayer?
    
    init() {
            configureAudioSession()
        }

        private func configureAudioSession() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Audio session error: \(error)")
            }
        }

    /// Play or loop background music
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "BackgroundMusic", withExtension: "mp3") else {
            print("Could not find background music file.")
            return
        }
        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundPlayer?.numberOfLoops = -1 // loop forever
            backgroundPlayer?.prepareToPlay()
            backgroundPlayer?.play()
        } catch {
            print("Error loading background music: \(error)")
        }
    }

    /// Stop the background music if it's playing
    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
        backgroundPlayer = nil
    }
    
    func setBackgroundMusicVolume(volume: Float) {
        backgroundPlayer?.volume = volume
    }

    /// Play a short sound effect (e.g., flip or match sound)
    func playSFX(_ filename: String, fileExtension: String = "wav", volume: Float = 1.5) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
            print("Could not find SFX file: \(filename).\(fileExtension)")
            return
        }
        do {
            sfxPlayer = try AVAudioPlayer(contentsOf: url)
            sfxPlayer?.volume = volume
            sfxPlayer?.prepareToPlay()
            sfxPlayer?.play()
        } catch {
            print("Error loading SFX: \(error)")
        }
    }
}
