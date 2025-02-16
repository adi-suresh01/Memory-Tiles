//
//  Difficulty.swift
//  Memory Tiles
//
//  Created by adi on 2/16/25.
//

import SwiftUI

struct DifficultyView: View {
    let selectedImage: String
    
    var body: some View {
        VStack {
            Text("Select Difficulty")
                .font(.title)
                .padding()

            NavigationLink(destination: GameView(selectedImage: selectedImage, gridSize: 4)) {
                Text("Easy (4x4)")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            NavigationLink(destination: GameView(selectedImage: selectedImage, gridSize: 5)) {
                Text("Medium (5x5)")
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            NavigationLink(destination: GameView(selectedImage: selectedImage, gridSize: 6)) {
                Text("Hard (6x6)")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
