//
//  PuzzleButtonStyle.swift
//  Memory Tiles
//
//  Created by adi on 2/19/25.
//

import SwiftUI

struct PuzzleButtonStyle: ButtonStyle {
    var backgroundColor: Color = .blue.opacity(0.8)
    var cornerRadius: CGFloat = 10
    var arcRadius: CGFloat = 10
    var caveDepth: CGFloat = 15
    var protrusionDepth: CGFloat = 15
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .frame(width: 200, height: 85)
            .foregroundColor(.white)
            .background(
                PuzzlePieceButtonShape(
                    cornerRadius: cornerRadius,
                    arcRadius: arcRadius,
                    caveDepth: caveDepth,
                    protrusionDepth: protrusionDepth
                )
                .fill(backgroundColor)
            )
            .clipShape(
                PuzzlePieceButtonShape(
                    cornerRadius: cornerRadius,
                    arcRadius: arcRadius,
                    caveDepth: caveDepth,
                    protrusionDepth: protrusionDepth
                )
            )
            .scaleEffect(configuration.isPressed ? 1.1 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

