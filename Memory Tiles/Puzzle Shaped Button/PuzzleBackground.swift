//
//  PuzzleBackground.swift
//  Memory Tiles
//
//  Created by adi on 2/19/25.
//

import SwiftUI

struct PuzzleBackgroundView: View {
    // Array of puzzle piece image names – add your assets here.
    let pieceImages = ["puzzlepiece1", "puzzlepiece2", "puzzlepiece3", "puzzlepiece4"]
    let numberOfPieces = 6

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<numberOfPieces, id: \.self) { index in
                    let imageName = pieceImages[index % pieceImages.count]
                    MovingPuzzlePieceView(imageName: imageName, containerSize: geometry.size)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct MovingPuzzlePieceView: View {
    let imageName: String
    let containerSize: CGSize
    @State private var position: CGPoint = .zero
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .position(position)
            .onAppear {
                // Set initial position.
                position = randomPosition(in: containerSize)
                animatePositionChange(in: containerSize)
            }
    }
    
    /// Animate the piece to a new random position over a random duration,
    /// then repeat.
    func animatePositionChange(in size: CGSize) {
        let newPos = randomPosition(in: size)
        let duration = Double.random(in: 3...6)
        withAnimation(Animation.easeInOut(duration: duration)) {
            position = newPos
        }
        // Schedule next move after the animation completes.
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            animatePositionChange(in: size)
        }
    }
    
    /// Returns a random position within the container,
    /// with a margin to keep pieces from going off-screen.
    func randomPosition(in size: CGSize) -> CGPoint {
        let margin: CGFloat = 80
        let x = CGFloat.random(in: margin...(size.width - margin))
        let y = CGFloat.random(in: margin...(size.height - margin))
        return CGPoint(x: x, y: y)
    }
}

struct PuzzleBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleBackgroundView()
    }
}

