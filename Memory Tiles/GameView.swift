//
//  ContentView.swift
//  Memory Tiles
//
//  Created by adi on 2/14/25.
//

import SwiftUI
import UIKit

struct TileCoordinate: Hashable {
    let row: Int
    let col: Int
}

struct GameView: View {
    let selectedImage: String
    let gridSize: Int

    @State private var tiles: [[Tile]] = []
    @State private var selectedTiles: [(row: Int, col: Int)] = []
    @State private var matchedTiles: Set<TileCoordinate> = []
    @State private var showWinMessage = false

    var body: some View {
        VStack {
            Text("Memory Puzzle Game")
                .font(.title)
                .padding()
            
            if tiles.isEmpty {
                ProgressView("Loading Tiles...")
            }
            else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: gridSize)) {
                    ForEach(0..<gridSize, id: \.self) { row in
                        ForEach(0..<gridSize, id: \.self) { col in
                            let tile = tiles[row][col]
                            TileView(tile: tile)
                                .onTapGesture {
                                    handleTileTap(row: row, col: col)
                                }
                        }
                    }
                }
                .padding()
            }
            if showWinMessage {
                Text("You Win! 🎉")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .onAppear {
            setupGame()
        }
    }

    
    private func setupGame() {
        guard let imageTiles = splitImage(imageName: selectedImage, gridSize: gridSize) else {
            print("Error: Could not split image")
            tiles = Array(repeating: Array(repeating: Tile(image: UIImage(), row: 0, col: 0), count: gridSize), count: gridSize) // Fallback empty grid
            return
        }

        var tempTiles: [[Tile]] = []
        for row in 0..<gridSize {
            var rowTiles: [Tile] = []
            for col in 0..<gridSize {
                let tile = Tile(image: imageTiles[row * gridSize + col], row: row, col: col)
                rowTiles.append(tile)
            }
            tempTiles.append(rowTiles)
        }
        
        tiles = shuffleTiles(tempTiles)
    }


    private func shuffleTiles(_ originalTiles: [[Tile]]) -> [[Tile]] {
        var flatTiles = originalTiles.flatMap { $0 }
        flatTiles.shuffle()

        var shuffledTiles: [[Tile]] = []
        for row in 0..<gridSize {
            let startIdx = row * gridSize
            let endIdx = startIdx + gridSize
            shuffledTiles.append(Array(flatTiles[startIdx..<endIdx]))
        }
        return shuffledTiles
    }

    private func handleTileTap(row: Int, col: Int) {
        guard !matchedTiles.contains(TileCoordinate(row: row, col: col)), !tiles[row][col].isFlipped else { return }

        tiles[row][col].isFlipped.toggle()
        selectedTiles.append((row, col))

        if selectedTiles.count == 2 {
            let first = selectedTiles[0]
            let second = selectedTiles[1]

            if isCorrectPair(first, second) {
                matchedTiles.insert(TileCoordinate(row: first.row, col: first.col))
                matchedTiles.insert(TileCoordinate(row: second.row, col: second.col))
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    tiles[first.row][first.col].isFlipped = false
                    tiles[second.row][second.col].isFlipped = false
                }
            }
            selectedTiles.removeAll()
        }

        checkWinCondition()
    }

    private func isCorrectPair(_ first: (row: Int, col: Int), _ second: (row: Int, col: Int)) -> Bool {
        return first.row + second.row == gridSize - 1 && first.col + second.col == gridSize - 1
    }

    private func checkWinCondition() {
        if matchedTiles.count == gridSize * gridSize {
            showWinMessage = true
        }
    }
}

struct TileView: View {
    var tile: Tile

    var body: some View {
        ZStack {
            if tile.isFlipped || tile.isMatched {
                Image(uiImage: tile.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 60, height: 60)
            }
        }
    }
}



//#Preview {
//    GameView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
