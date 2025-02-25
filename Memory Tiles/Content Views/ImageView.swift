//
//  Image.swift
//  Memory Tiles
//
//  Created by adi on 2/16/25.
//

import SwiftUI

struct ImageView: View {
    let images = ["image1", "image2", "image3"]
    
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Select an Image")
                    .font(.custom("Chalkboard SE", size: 40))
                    .foregroundColor(Color(red: 245/255, green: 215/255, blue: 135/255))
                    .padding()
                
                ForEach(images, id: \.self) { image in
                    NavigationLink(destination: DifficultyView(selectedImage: image)) {
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
                            .padding()
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                                AudioManager.shared.playSFX("click")
                            })
                }
            }
        }
    }
}
