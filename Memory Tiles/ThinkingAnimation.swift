//
//  ThinkingAnimation.swift
//  Memory Tiles
//
//  Created by adi on 2/19/25.
//

import SwiftUI

/// Displays "Memory Mosaic" with a per-letter animation.
struct AnimatedTitleView: View {
    let phrase = "Memory Mosaic"
    @State private var thinking = false
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(phrase.enumerated()), id: \.offset) { index, letter in
                Text(String(letter))
                    .foregroundStyle(.white)
                    // Example transformations
                    .hueRotation(.degrees(thinking ? 220 : 0))
                    .opacity(thinking ? 1 : 0)
                    .scaleEffect(thinking ? 1 : 0.5, anchor: .bottom)
                    // Animate each letter with a small delay
                    .animation(
                        .easeInOut(duration: 0.9)
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) / 20),
                        value: thinking
                    )
            }
        }
        .onAppear {
            // Trigger the animation once the view appears
            thinking = true
        }
    }
}

