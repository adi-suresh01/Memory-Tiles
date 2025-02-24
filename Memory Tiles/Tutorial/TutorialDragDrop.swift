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
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .offset(x: 0, y: 0)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: 20) {
                    Text("Drag and Drop")
                        .font(.custom("Chalkboard SE", size: 40))
                        .foregroundColor(.black)
                        .padding(.top, 40)
                    
                    Text("""
                     Drag and drop the puzzle pieces to rebuild the image. Once everything’s in the right spot, hit submit for your score. Can you beat the 2-minute mark?
                     """)
                    .font(.custom("Chalkboard SE", size: 18))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    
                    // Reference preview of the completed image.
                    VStack {
//                        Text("Reference Image")
//                            .font(.headline)
                        Image(demoImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .cornerRadius(1)
                    }
                    .padding(.top, 10)
                    
                    // Continue button takes the user to the actual game screen.
//                    NavigationLink(destination: HomeView()) {
//                        Text("Continue")
//                            .font(.custom("Chalkboard SE", size: 30))
//                            .foregroundColor(Color(red: 245/255, green: 215/255, blue: 135/255))
////                            .padding()
////                            .frame(maxWidth: .infinity)
////                            .background(Color.blue)
////                            .foregroundColor(.white)
////                            .cornerRadius(8)
////                            .padding(.horizontal)
//                    }
//                    .buttonStyle(
//                        PuzzleButtonStyle(
//                                 backgroundColor: .green.opacity(1),
//                                 cornerRadius: 0,
//                                 arcRadius: 25,
//                                 caveDepth: 36,
//                                 protrusionDepth: 36
//                                 )
//                        )
//                    .offset(x: 0, y: 40)
//                    .padding(.bottom)
                }
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
