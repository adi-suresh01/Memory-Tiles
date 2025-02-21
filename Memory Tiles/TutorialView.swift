//
//  TutorialView.swift
//  Memory Tiles
//
//  Created by adi on 2/16/25.
//

import SwiftUI
import UIKit

struct TutorialView: View {
    @Environment(\.presentationMode) var presentationMode
    let gridSize: Int = 4
    let demoImage: String = "image_test"
    
    @State private var tiles: [[Tile]] = []
    @State private var currentPairIndex: Int = 0
    // highlightPhase == 0: highlight the first tile; 1: highlight its partner.
    @State private var highlightPhase: Int = 0
    @State private var pairs: [((Int, Int), (Int, Int))] = []
    
    var body: some View {
        ScrollView {
            ZStack{
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 20) {
                    Text("Tutorial: Pair Identification")
                        .font(.largeTitle)
                        .padding(.top)
                    
                    Text("""
                    In Memory Puzzle Game, the image is split into tiles.
                    Correct pairs are defined as mirror images across the diagonal.
                    For example, the tile at [0,0] belongs with the tile at [3,3].
                    """)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    
                    if tiles.isEmpty {
                        ProgressView("Loading demo...")
                    } else {
                        let columns = Array(repeating: GridItem(.flexible()), count: gridSize)
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(0..<(gridSize * gridSize), id: \.self) { index in
                                let row = index / gridSize
                                let col = index % gridSize
                                let tile = tiles[row][col]
                                ZStack {
                                    TileView(tile: tile, tileSize: 80)
                                    if isTileHighlighted(row: row, col: col) {
                                        Circle()
                                            .stroke(Color.red, lineWidth: 4)
                                            .frame(width: 90, height: 90)
                                            .transition(.opacity)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    
                    NavigationLink(destination: TutorialFindPairView()) {
                        Text("Next")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                }
            }
            .navigationBarTitle("Instructions", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear {
                setupBoard()
                pairs = computePairs()
                startHighlightCycle()
            }
        }
    }
    
    
    private func isTileHighlighted(row: Int, col: Int) -> Bool {
        guard pairs.indices.contains(currentPairIndex) else { return false }
        let pair = pairs[currentPairIndex]
        if highlightPhase == 0 {
            return row == pair.0.0 && col == pair.0.1
        } else {
            return row == pair.1.0 && col == pair.1.1
        }
    }
    
    private func setupBoard() {
        guard let imageTiles = splitImage(imageName: demoImage, gridSize: gridSize) else { return }
        var newGrid: [[Tile]] = []
        for row in 0..<gridSize {
            var rowTiles: [Tile] = []
            for col in 0..<gridSize {
                let index = row * gridSize + col
                var tile = Tile(image: imageTiles[index],
                                correctRow: row,
                                correctCol: col,
                                currentRow: row,
                                currentCol: col)
                tile.isFlipped = true // Show solved state.
                rowTiles.append(tile)
            }
            newGrid.append(rowTiles)
        }
        tiles = newGrid
    }
    
    private func computePairs() -> [((Int, Int), (Int, Int))] {
        var result: [((Int, Int), (Int, Int))] = []
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let partner = (gridSize - 1 - row, gridSize - 1 - col)
                if (row, col) < partner {
                    result.append(((row, col), partner))
                }
            }
        }
        return result
    }
    
    private func startHighlightCycle() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                highlightPhase = (highlightPhase + 1) % 2
            }
            if highlightPhase == 0 {
                currentPairIndex = (currentPairIndex + 1) % pairs.count
            }
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TutorialView()
        }
    }
}
