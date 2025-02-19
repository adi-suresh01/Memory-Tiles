//
//  HomeView.swift
//  Memory Tiles
//
//  Created by adi on 2/16/25.
//

import SwiftUI

struct HomeView: View {
    @State private var bouncePlay = false
    @State private var bounceInstructions = false

    var body: some View {
        NavigationView {
            ZStack {
                // Full-screen background image.
                
                Image("background_image")
                    .resizable()
                    .scaledToFill()
                    .offset(x: 0, y: 0)
                    .edgesIgnoringSafeArea(.all)
                
//                PuzzleBackgroundView()
//                                    .blur(radius: 5)
//                                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 40) {
                    Spacer()
                    
//                    Text("Memory Mosaic")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .shadow(radius: 10)
//                        .padding()
                    TypewriterTitleView(phrase: "Memory Mosaic")
                    
                    NavigationLink(destination: ImageView()) {
                        Text("Play")
                            .font(.custom("Chalkboard SE", size: 30))
                            .foregroundColor(Color(red: 245/255, green: 215/255, blue: 135/255))
//                            .font(.title2)
//                            .padding()
//                            .frame(width: 250, height: 50)
//                            .background(
//                                RoundedRectangle(cornerRadius: 25)
//                                    .fill(Color.blue.opacity(0.8))
//                            )
//                            .foregroundColor(.white)
                    }
                    .buttonStyle(
                        PuzzleButtonStyle(
                                 backgroundColor: .blue.opacity(0.8),
                                 cornerRadius: 0,
                                 arcRadius: 25,
                                 caveDepth: 36,
                                 protrusionDepth: 36
                                 )
                        )
                    .scaleEffect(bouncePlay ? 1.05 : 0.95)
                    .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: bouncePlay)
                    .onAppear {
                        bouncePlay = true
                    }
                    
                    NavigationLink(destination: TutorialView()) {
                        Text("Instructions")
                            .font(.custom("Chalkboard SE", size: 30))
                            .foregroundColor(Color(red: 245/255, green: 215/255, blue: 135/255))
//                            .font(.title2)
//                            .padding()
//                            .frame(width: 250, height: 50)  // Fixed button size.
//                            .background(
//                                RoundedRectangle(cornerRadius: 25)
//                                    .fill(Color.green.opacity(0.8))
//                            )
//                            .foregroundColor(.white)
                    }
                    .buttonStyle(
                        PuzzleButtonStyle(
                                 backgroundColor: .green.opacity(1),
                                 cornerRadius: 0,
                                 arcRadius: 25,
                                 caveDepth: 36,
                                 protrusionDepth: 36
                                 )
                        )
                    .scaleEffect(bounceInstructions ? 1.05 : 0.95)
                    .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: bounceInstructions)
                    .onAppear {
                        bounceInstructions = true
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


