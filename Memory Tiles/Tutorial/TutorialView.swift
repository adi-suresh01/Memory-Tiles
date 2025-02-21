//
//  TutorialView.swift
//  Memory Tiles
//
//  Created by adi on 2/16/25.
//

import SwiftUI
import UIKit

struct TutorialView: View {
    let gridSize: Int = 4
    let demoImage: String = "image_test"
    
    @State private var tiles: [[Tile]] = []
    @State private var currentPairIndex: Int = 0
    @State private var highlightPhase: Int = 0
    @State private var pairs: [((Int, Int), (Int, Int))] = []
    
    private let highlightColors: [Color] = [
        .red, .blue, .green, .yellow, .orange, .purple, .gray, .brown
    ]
    
    // Make nav bar transparent in init
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        // Make the title text white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        // Apply to standard and scrollEdge appearances
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            // 1) Full-screen background image
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // 2) Scrollable content so you can add more instructions
            ScrollView {
                VStack(spacing: 20) {
                    // Enough top padding so text is visible below the transparent nav bar
                    Spacer().frame(height: 80)
                    
                    Text("Pair Identification")
                        .offset(x: 0, y: -30)
                        .font(.custom("Chalkboard SE", size: 30))
                        .foregroundColor(.black)
                        .padding(.horizontal)
                    
                    Text("""
                    In Memory Puzzle Game, the image is split into tiles.
                    Correct pairs are defined as mirror images across the diagonal.
                    For example, the tile at [0,0] belongs with the tile at [3,3].
                    """)
                    .offset(x: 0, y: -30)
                    .font(.custom("Chalkboard SE", size: 18))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
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
                                            .stroke(highlightColors[currentPairIndex], lineWidth: 4)
                                            .frame(width: 100, height: 100)
                                            .transition(.opacity)
                                    }
                                }
                            }
                        }
                        .offset(x: 0, y: -30)
                        .padding()
                    }
                    
                    NavigationLink(destination: TutorialFindPairView()) {
                        Text("Next")
                            .font(.custom("Chalkboard SE", size: 30))
                            .foregroundColor(Color(red: 245/255, green: 215/255, blue: 135/255))
//                            .font(.headline)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.blue.opacity(0.8))
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                            .padding(.horizontal, 20)
                    }
                    .offset(x: 0, y: -30)
                    .buttonStyle(
                        PuzzleButtonStyle(
                            backgroundColor: .green.opacity(1),
                                 cornerRadius: 0,
                                 arcRadius: 25,
                                 caveDepth: 36,
                                 protrusionDepth: 36
                                 )
                        )
                    
                    // Enough bottom padding so the button doesn't get cut off
                    Spacer().frame(height: 60)
                }
            }
        }
        // Keep a navigation title if you want a small inline title
        .navigationBarTitle("Tutorial", displayMode: .inline)
        .onAppear {
            setupBoard()
            pairs = computePairs()
            startHighlightCycle()
        }
    }
    
    // MARK: - Highlight Logic
    
    private func isTileHighlighted(row: Int, col: Int) -> Bool {
        guard pairs.indices.contains(currentPairIndex) else { return false }
        let pair = pairs[currentPairIndex]
        return (highlightPhase == 0)
            ? (row == pair.0.0 && col == pair.0.1)
            : (row == pair.1.0 && col == pair.1.1)
    }
    
    // MARK: - Setup Board
    
    private func setupBoard() {
        guard let imageTiles = splitImage(imageName: demoImage, gridSize: gridSize) else { return }
        var newGrid: [[Tile]] = []
        for row in 0..<gridSize {
            var rowTiles: [Tile] = []
            for col in 0..<gridSize {
                let index = row * gridSize + col
                var tile = Tile(
                    image: imageTiles[index],
                    correctRow: row,
                    correctCol: col,
                    currentRow: row,
                    currentCol: col
                )
                tile.isFlipped = true // Show solved state
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
