//
//  Memory_TilesApp.swift
//  Memory Tiles
//
//  Created by adi on 2/14/25.
//

import SwiftUI

@main
struct Memory_TilesApp: App {
    // Track mute state here so the button always reflects the current volume state
    @State private var isMuted = false

    init() {
        // Start background music right away
        AudioManager.shared.playBackgroundMusic()
    }

    var body: some Scene {
        WindowGroup {
            // A ZStack to overlay a global button on top of the HomeView
            ZStack(alignment: .bottomTrailing) {
                // Your main content
                HomeView()

                // Volume/mute button pinned bottom-right
                Button {
                    isMuted.toggle()
                    let newVolume: Float = isMuted ? 0.0 : 1.0
                    AudioManager.shared.setBackgroundMusicVolume(volume: newVolume)
                } label: {
                    Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.3.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .padding(12)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(16)
                        .foregroundColor(.white)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 40)
            }
        }
    }
}


