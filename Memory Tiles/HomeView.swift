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
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    Text("Memory Puzzle Game")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .padding()
                    
                    NavigationLink(destination: ImageView()) {
                        Text("Play")
                            .font(.title2)
                            .padding()
                            .frame(width: 250, height: 50)  // Fixed button size.
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .scaleEffect(bouncePlay ? 1.05 : 0.95)
                    .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: bouncePlay)
                    .onAppear {
                        bouncePlay = true
                    }
                    
                    NavigationLink(destination: TutorialView()) {
                        Text("Instructions")
                            .font(.title2)
                            .padding()
                            .frame(width: 250, height: 50)  // Fixed button size.
                            .background(Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
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


