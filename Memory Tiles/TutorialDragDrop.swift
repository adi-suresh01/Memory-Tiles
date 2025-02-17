//
//  TutorialDragDrop.swift
//  Memory Tiles
//
//  Created by adi on 2/16/25.
//

import SwiftUI
import UIKit

struct TutorialDragDropView: View {
    // Use the demo image as reference.
    let demoImage: String = "image_test"
    let gridSize: Int = 4

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Tutorial: Drag and Drop")
                    .font(.largeTitle)
                    .padding(.top)

                Text("""
                     In Memory Puzzle Game, after you flip a correct pair of tiles,
                     you must drag and drop them into their proper positions to complete the puzzle.
                     
                     You can use the completed image shown below as a reference to guide your moves.
                     """)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Reference preview of the completed image.
                VStack {
                    Text("Reference Image")
                        .font(.headline)
                    Image(demoImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .cornerRadius(8)
                }
                .padding(.top, 10)

                // Continue button takes the user to the actual game screen.
                NavigationLink(destination: ImageView()) {
                    Text("Continue")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.bottom)
            }
        }
    }
}

struct TutorialDragDropView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TutorialDragDropView()
        }
    }
}
