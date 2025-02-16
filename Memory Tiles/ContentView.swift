//
//  ContentView.swift
//  Memory Tiles
//
//  Created by adi on 2/14/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedImage: String? = nil
    @State private var difficulty: Difficulty? = nil
    @State private var showDifficultySelection = false
    
    let images = ["image1", "image2", "image3"]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Select an Image")
                    .font(.title)
                    .padding()
                
                HStack {
                    ForEach(images, id: \..self) { image in
                        Button(action: {
                            selectedImage = image
                            showDifficultySelection = true
                        }) {
                            Image(image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .border(Color.blue, width: selectedImage == image ? 3 : 0)
                        }
                    }
                }
                
                if showDifficultySelection {
                    Text("Select Difficulty")
                        .font(.headline)
                        .padding()
                    
                    HStack {
                        ForEach(Difficulty.allCases, id: \..self) { level in
                            Button(action: {
                                difficulty = level
                            }) {
                                Text(level.rawValue)
                                    .padding()
                                    .background(difficulty == level ? Color.blue : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                
                if let selectedImage = selectedImage, let difficulty = difficulty {
                    NavigationLink(destination: GameView(imageName: selectedImage, difficulty: difficulty)) {
                        Text("Start Game")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
    }
}

enum Difficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var gridSize: Int {
        switch self {
        case .easy: return 4
        case .medium: return 5
        case .hard: return 6
        }
    }
}

struct GameView: View {
    let imageName: String
    let difficulty: Difficulty
    
    @State private var tiles: [[Tile]] = []
    @State private var matchedTiles: Set<Int> = []
    
    var body: some View {
        VStack {
            Text("Memory Jigsaw Game")
                .font(.title)
                .padding()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: difficulty.gridSize)) {
                ForEach(tiles.flatMap { $0 }, id: \..id) { tile in
                    TileView(tile: tile, isMatched: matchedTiles.contains(tile.id))
                        .onTapGesture {
                            handleTileTap(tile)
                        }
                }
            }
        }
        .onAppear {
            setupGame()
        }
    }
    
    private func setupGame() {
        let size = difficulty.gridSize
        tiles = (0..<size).map { row in
            (0..<size).map { col in
                Tile(id: row * size + col, imageName: imageName, position: (row, col))
            }
        }.shuffled()
    }
    
    private func handleTileTap(_ tile: Tile) {
        // Implement logic for flipping and matching tiles
    }
}

struct TileView: View {
    let tile: Tile
    let isMatched: Bool
    
    var body: some View {
        ZStack {
            if isMatched {
                Rectangle()
                    .fill(Color.clear)
            } else {
                Rectangle()
                    .fill(Color.blue)
                    .overlay(Text("?"))
            }
        }
        .frame(width: 50, height: 50)
        .cornerRadius(5)
    }
}

struct Tile: Identifiable {
    let id: Int
    let imageName: String
    let position: (Int, Int)
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
