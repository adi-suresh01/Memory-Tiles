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
    let revealInterval: UInt64 = 110_000_000  // nanoseconds between each character
    
    @State private var currentText: String = ""
    @State private var typingTask: Task<Void, Never>? = nil
    
    var body: some View {
        Text(currentText)
            .font(.custom("Chalkboard SE", size: 50))
            .foregroundColor(Color(red: 245/255, green: 215/255, blue: 135/255))
//            .fontWeight(.bold)
            .onAppear {
                startTyping()
            }
            .onDisappear {
                typingTask?.cancel()
                typingTask = nil
                currentText = ""
            }
    }
    
    private func startTyping() {
            // If there's already a typing task, cancel it before starting again
            typingTask?.cancel()
            
            // Start a new async task
            typingTask = Task {
                // Ensure text is empty at the start
                currentText = ""
                
                // Loop over each character in the phrase
                for char in phrase {
                    // Append the character
                    currentText.append(char)
                    
                    // Sleep for revealInterval
                    do {
                        try await Task.sleep(nanoseconds: revealInterval)
                    } catch {
                        // If the task was canceled, exit gracefully
                        return
                    }
                }
                // Once complete, we can optionally do something else if desired
            }
        }
    }
