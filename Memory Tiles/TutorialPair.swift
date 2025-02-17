//
//  TutorialPair.swift
//  Memory Tiles
//
//  Created by adi on 2/16/25.
//

import SwiftUI
import UIKit

struct TutorialFindPairView: View {
    let gridSize: Int = 4
    let demoImage: String = "image_test"
    
    @State private var tiles: [[Tile]] = []
    @State private var cpuPairFound: Bool = false
    
    let instructions: String = """
    In this tutorial, the board is first closed and shuffled.
    The CPU randomly flips two tiles.
    If they form a correct pair (mirror images across the diagonal), they remain open.
    Otherwise, they flip back and the CPU tries again.
    """
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Tutorial: Finding a Pair")
                        .font(.title2)
                        .padding(.top, 16)
                    
                    Text(instructions)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    if tiles.isEmpty {
                        ProgressView("Loading board...")
                    } else {
                        let columns = Array(repeating: GridItem(.flexible()), count: gridSize)
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(0..<(gridSize * gridSize), id: \.self) { index in
                                let row = index / gridSize
                                let col = index % gridSize
                                let tile = tiles[row][col]
                                TileView(tile: tile)
                            }
                        }
                        .padding()
                    }
                    
                    VStack {
                        Image(demoImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                    }
                    .padding(.top, 10)
                }
            }
            
            // Continue button always visible at the bottom.
            NavigationLink(destination: TutorialDragDropView()) {
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
        .onAppear {
            setupBoard()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                simulateCPUSearch()
            }
        }
        .navigationBarTitle("Instructions", displayMode: .inline)
        // Remove any explicit back button toolbar items.
        .navigationBarBackButtonHidden(false)
    }
    
    // MARK: - Board Setup
    
    private func setupBoard() {
        guard let imageTiles = splitImage(imageName: demoImage, gridSize: gridSize) else {
            print("Error: Could not split demo image")
            return
        }
        var correctTiles: [Tile] = []
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let index = row * gridSize + col
                let tile = Tile(
                    image: imageTiles[index],
                    correctRow: row,
                    correctCol: col,
                    currentRow: row,
                    currentCol: col
                )
                correctTiles.append(tile)
            }
        }
        let shuffledTiles = correctTiles.shuffled()
        var newGrid: [[Tile]] = []
        for row in 0..<gridSize {
            var rowTiles: [Tile] = []
            for col in 0..<gridSize {
                let index = row * gridSize + col
                var tile = shuffledTiles[index]
                tile.currentRow = row
                tile.currentCol = col
                tile.isFlipped = false // All tiles start closed.
                tile.isMatched = false
                rowTiles.append(tile)
            }
            newGrid.append(rowTiles)
        }
        self.tiles = newGrid
    }
    
    // MARK: - CPU Search Simulation
    
    private func simulateCPUSearch() {
        if cpuPairFound { return }
        
        var availablePositions: [(Int, Int)] = []
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if !tiles[row][col].isMatched && !tiles[row][col].isFlipped {
                    availablePositions.append((row, col))
                }
            }
        }
        if availablePositions.count < 2 { return }
        availablePositions.shuffle()
        let firstPos = availablePositions[0]
        let secondPos = availablePositions[1]
        
        withAnimation(.easeInOut(duration: 0.5)) {
            var tile = tiles[firstPos.0][firstPos.1]
            tile.isFlipped = true
            tiles[firstPos.0][firstPos.1] = tile
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation(.easeInOut(duration: 0.5)) {
                var tile = tiles[secondPos.0][secondPos.1]
                tile.isFlipped = true
                tiles[secondPos.0][secondPos.1] = tile
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                let tile1 = tiles[firstPos.0][firstPos.1]
                let tile2 = tiles[secondPos.0][secondPos.1]
                if isCorrectPair(tile1, tile2) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        var updatedTile1 = tile1
                        updatedTile1.isMatched = true
                        tiles[firstPos.0][firstPos.1] = updatedTile1
                        
                        var updatedTile2 = tile2
                        updatedTile2.isMatched = true
                        tiles[secondPos.0][secondPos.1] = updatedTile2
                    }
                    cpuPairFound = true
                } else {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        var updatedTile1 = tile1
                        updatedTile1.isFlipped = false
                        tiles[firstPos.0][firstPos.1] = updatedTile1
                        
                        var updatedTile2 = tile2
                        updatedTile2.isFlipped = false
                        tiles[secondPos.0][secondPos.1] = updatedTile2
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        simulateCPUSearch()
                    }
                }
            }
        }
    }
    
    private func isCorrectPair(_ first: Tile, _ second: Tile) -> Bool {
        return (first.correctRow + second.correctRow == gridSize - 1) &&
               (first.correctCol + second.correctCol == gridSize - 1)
    }
}

struct TutorialFindPairView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TutorialFindPairView()
        }
    }
}








