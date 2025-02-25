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
        ZStack{
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Select Difficulty")
                    .font(.custom("Chalkboard SE", size: 50))
                    .foregroundColor(Color(red: 245/255, green: 215/255, blue: 135/255))
                    .padding(.top, -150)
                
                NavigationLink(destination: GameView(selectedImage: selectedImage, gridSize: 4)) {
                    Text("Easy (4x4)")
                        .font(.custom("Chalkboard SE", size: 30))
                        .foregroundColor(Color(red: 245/255, green: 215/255, blue: 135/255))
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
                }
                .padding(.top, -60)
                .simultaneousGesture(TapGesture().onEnded {
                            AudioManager.shared.playSFX("click")
                        })
                .buttonStyle(
                    PuzzleButtonStyle(
                             backgroundColor: .blue.opacity(0.8),
                             cornerRadius: 0,
                             arcRadius: 25,
                             caveDepth: 36,
                             protrusionDepth: 36
                             )
                    )
                
                NavigationLink(destination: GameView(selectedImage: selectedImage, gridSize: 6)) {
                    Text("Hard (6x6)")
                        .font(.custom("Chalkboard SE", size: 30))
                        .foregroundColor(Color(red: 245/255, green: 215/255, blue: 135/255))
//                        .padding()
//                        .background(Color.orange)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
                }
                .offset(x: 0, y: 40)
                .simultaneousGesture(TapGesture().onEnded {
                            AudioManager.shared.playSFX("click")
                        })
                .buttonStyle(
                    PuzzleButtonStyle(
                             backgroundColor: .red.opacity(0.8),
                             cornerRadius: 0,
                             arcRadius: 25,
                             caveDepth: 36,
                             protrusionDepth: 36
                             )
                    )
                
//                NavigationLink(destination: GameView(selectedImage: selectedImage, gridSize: 6)) {
//                    Text("Hard (6x6)")
//                        .font(.custom("Chalkboard SE", size: 30))
////                        .padding()
////                        .background(Color.red)
////                        .foregroundColor(.white)
////                        .cornerRadius(10)
//                }
//                .buttonStyle(
//                    PuzzleButtonStyle(
//                             backgroundColor: .red.opacity(0.8),
//                             cornerRadius: 0,
//                             arcRadius: 25,
//                             caveDepth: 36,
//                             protrusionDepth: 36
//                             )
//                    )
            }
        }
    }
}
