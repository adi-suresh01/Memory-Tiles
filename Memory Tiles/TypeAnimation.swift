//
//  TypeAnimation.swift
//  Memory Tiles
//
//  Created by adi on 2/19/25.
//

import SwiftUI
import Combine

/// A view that reveals the given phrase one character at a time, like a typewriter.
/// Once all characters are revealed, it stays in place.
struct TypewriterTitleView: View {
    let phrase: String
    let revealInterval: Double = 0.11  // seconds between each character
    
    @State private var currentText: String = ""
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        Text(currentText)
            .font(.custom("Chalkboard SE", size: 50))
            .foregroundColor(Color(red: 245/255, green: 215/255, blue: 135/255))
//            .fontWeight(.bold)
            .onAppear {
                startTypewriter()
            }
            .onDisappear {
                cancellable?.cancel()
            }
    }
    
    private func startTypewriter() {
        var index = 0
        // Publish a tick every `revealInterval` seconds.
        cancellable = Timer.publish(every: revealInterval, on: .main, in: .common)
            .autoconnect()
            .delay(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink { _ in
                if index < phrase.count {
                    let charIndex = phrase.index(phrase.startIndex, offsetBy: index)
                    currentText.append(phrase[charIndex])
                    index += 1
                } else {
                    // Once done, stop publishing.
                    cancellable?.cancel()
                }
            }
    }
}

