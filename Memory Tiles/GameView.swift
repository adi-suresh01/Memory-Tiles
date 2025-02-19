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

    @Environment(\.dismiss) private var dismiss
    
    // Game state
    @State private var tiles: [[Tile]] = []             // 2D grid of tiles
    @State private var selectedTiles: [Tile] = []         // Tiles selected during memory phase
    @State private var showWinMessage = false
    @State private var submitMessage = ""  // Optional message to inform the user if puzzle isn't complete

    @State private var timeRemaining = 120
    @State private var timer: Timer? = nil
    @State private var showGameOver = false
    
    var computedTileSize: CGFloat {
        switch gridSize {
        case 4:
            return 80
        case 5:
            return 60
        case 6:
            return 50
        default:
            return 60
        }
    }
    
    var body: some View {
        ZStack {
            // Full-screen background image.
            
            Image("background")
                .resizable()
                .scaledToFill()
                .offset(x: 0, y: 0)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 16) {
                Text("Memory Mosaic")
                    .font(.custom("Chalkboard SE", size: 40))
                    .foregroundColor(Color(red: 245/255, green: 215/255, blue: 135/255))
                    .padding()
                
                Text("Time Left: \(timeRemaining) s")
                                .font(.headline)
                                .foregroundColor(.red)
                
                if tiles.isEmpty {
                    ProgressView("Loading Tiles...")
                } else {
                    // Build grid from flattened tile array.
                    let columns = Array(repeating: GridItem(.flexible()), count: gridSize)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(0..<(gridSize * gridSize), id: \.self) { index in
                            let row = index / gridSize
                            let col = index % gridSize
                            let tile = tiles[row][col]
                            ZStack {
                                TileView(tile: tile, tileSize: computedTileSize)
                                    .onTapGesture {
                                        handleTileTap(atRow: row, col: col)
                                    }
                                    .onDrag {
                                        // Allow dragging only if tile is flipped and not already matched.
                                        if tile.isFlipped && !tile.isMatched {
                                            return NSItemProvider(object: tile.id.uuidString as NSString)
                                        }
                                        return NSItemProvider()
                                    }
                            }
                            .onDrop(of: ["public.text"], isTargeted: nil) { providers in
                                if let provider = providers.first {
                                    _ = provider.loadObject(ofClass: String.self) { (object, error) in
                                        if let idString = object, let uuid = UUID(uuidString: idString) {
                                            DispatchQueue.main.async {
                                                self.handleDrop(draggedTileId: uuid, targetRow: row, targetCol: col)
                                            }
                                        }
                                    }
                                    return true
                                }
                                return false
                            }
                        }
                    }
                    .padding()
                }
                
                // Reference image section
                VStack {
//                    Text("Reference Image")
//                        .font(.headline)
                    Image(selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .cornerRadius(8)
                }
                .padding(.top, 10)
                
                // Submit Button Section
                Button("Submit") {
                    submitPuzzle()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                // Optionally show a message if puzzle is incomplete.
                if !submitMessage.isEmpty {
                    Text(submitMessage)
                        .foregroundColor(.red)
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
                startTimer()
            }
            .onDisappear {
                timer?.invalidate()
            }
            
            .alert("Time's up!", isPresented: $showGameOver) {
                Button("Restart", action: restartGame)
                Button("Home", role: .cancel, action: goHome)
            } message: {
                Text("You ran out of time!")
            }
        }
    }
    // MARK: - Timer Logic

        private func startTimer() {
            timer?.invalidate()       // Just to be safe
            timeRemaining = 120       // 2 minutes
            showGameOver = false
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
                if timeRemaining <= 0 {
                    timeRemaining = 0
                    timer?.invalidate()
                    showGameOver = true
                }
            }
        }
    private func restartGame() {
        // Reset states
        showWinMessage = false
        submitMessage = ""
        setupGame()
        startTimer()
    }

    private func goHome() {
        // If you only need to pop one level:
        dismiss()
        // If you need to pop multiple levels, you might do so in your navigation structure
    }
    // MARK: - Game Setup

    private func setupGame() {
        guard let imageTiles = splitImage(imageName: selectedImage, gridSize: gridSize) else {
            print("Error: Could not split image")
            tiles = Array(
                repeating: Array(
                    repeating: Tile(image: UIImage(), correctRow: 0, correctCol: 0, currentRow: 0, currentCol: 0),
                    count: gridSize
                ),
                count: gridSize
            )
            return
        }

        var correctTiles: [Tile] = []
        // Create tiles with their original positions (0-indexed).
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

        // Shuffle the tiles.
        let shuffledTiles = correctTiles.shuffled()

        // Build a new 2D grid, updating each tile’s current position according to its new location.
        var newGrid: [[Tile]] = []
        for row in 0..<gridSize {
            var rowTiles: [Tile] = []
            for col in 0..<gridSize {
                let index = row * gridSize + col
                var tile = shuffledTiles[index]
                tile.currentRow = row
                tile.currentCol = col
                rowTiles.append(tile)
            }
            newGrid.append(rowTiles)
        }
        self.tiles = newGrid
    }

    // MARK: - Memory Phase

    private func handleTileTap(atRow row: Int, col: Int) {
        var tile = tiles[row][col]
        // Only allow tap if the tile is not already flipped or matched.
        if tile.isFlipped || tile.isMatched { return }

        // Flip the tile.
        tile.isFlipped = true
        updateTile(tile, atRow: row, col: col)
        selectedTiles.append(tile)

        // When two tiles are selected, check for a correct match.
        if selectedTiles.count == 2 {
            let first = selectedTiles[0]
            let second = selectedTiles[1]
            if isCorrectPair(first, second) {
                // Correct pair: leave them flipped so they become draggable.
            } else {
                // Wrong pair: flip them back after a short delay.
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    resetTileFlip(first)
                    resetTileFlip(second)
                }
            }
            selectedTiles.removeAll()
        }
    }

    private func updateTile(_ tile: Tile, atRow row: Int, col: Int) {
        tiles[row][col] = tile
    }

    private func resetTileFlip(_ tile: Tile) {
        if let pos = findTilePosition(by: tile.id) {
            var updatedTile = tiles[pos.row][pos.col]
            updatedTile.isFlipped = false
            updateTile(updatedTile, atRow: pos.row, col: pos.col)
        }
    }

    // Returns true if the two tiles form a correct pair based on their original positions.
    private func isCorrectPair(_ first: Tile, _ second: Tile) -> Bool {
        return (first.correctRow + second.correctRow == gridSize - 1) &&
               (first.correctCol + second.correctCol == gridSize - 1)
    }

    // MARK: - Drag and Drop Rearrangement

    func handleDrop(draggedTileId: UUID, targetRow: Int, targetCol: Int) {
        guard let sourcePos = findTilePosition(by: draggedTileId) else { return }
        let sourceRow = sourcePos.row
        let sourceCol = sourcePos.col

        if sourceRow == targetRow && sourceCol == targetCol { return }

        var draggedTile = tiles[sourceRow][sourceCol]
        let targetTile = tiles[targetRow][targetCol]

        // Only allow drop if the dragged tile is flipped and not already matched.
        if !draggedTile.isFlipped || draggedTile.isMatched { return }
        if targetTile.isMatched { return }

        // Swap positions: assign the dragged tile to the target cell…
        draggedTile.currentRow = targetRow
        draggedTile.currentCol = targetCol

        // …and move the tile currently at the target to the dragged tile’s old cell.
        var newTargetTile = targetTile
        newTargetTile.currentRow = sourceRow
        newTargetTile.currentCol = sourceCol

        tiles[targetRow][targetCol] = draggedTile
        tiles[sourceRow][sourceCol] = newTargetTile

        // If the dragged tile is now in its correct position, mark it as matched.
        if draggedTile.currentRow == draggedTile.correctRow &&
           draggedTile.currentCol == draggedTile.correctCol {
            draggedTile.isMatched = true
            updateTile(draggedTile, atRow: targetRow, col: targetCol)
        }

        randomizeNonMatchedTiles()
        checkWinCondition()
    }

    private func randomizeNonMatchedTiles() {
        var nonMatchedTiles: [Tile] = []
        var availablePositions: [(row: Int, col: Int)] = []

        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if !tiles[row][col].isMatched {
                    nonMatchedTiles.append(tiles[row][col])
                    availablePositions.append((row, col))
                }
            }
        }

        availablePositions.shuffle()

        for (index, tile) in nonMatchedTiles.enumerated() {
            var updatedTile = tile
            let pos = availablePositions[index]
            updatedTile.currentRow = pos.row
            updatedTile.currentCol = pos.col
            tiles[pos.row][pos.col] = updatedTile
        }
    }

    private func findTilePosition(by id: UUID) -> (row: Int, col: Int)? {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if tiles[row][col].id == id {
                    return (row, col)
                }
            }
        }
        return nil
    }

    private func checkWinCondition() {
        let totalTiles = gridSize * gridSize
        var matchedCount = 0
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if tiles[row][col].isMatched {
                    matchedCount += 1
                }
            }
        }
        if matchedCount == totalTiles {
            showWinMessage = true
        }
    }

    // MARK: - Submit Puzzle

    /// When the user taps the submit button, verify that every tile's current position matches its correct position.
    private func submitPuzzle() {
        var isSolved = true
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let tile = tiles[row][col]
                if tile.currentRow != tile.correctRow || tile.currentCol != tile.correctCol {
                    isSolved = false
                    break
                }
            }
            if !isSolved { break }
        }
        if isSolved {
            showWinMessage = true
            submitMessage = ""
        } else {
            // Optionally update a message so the user knows the puzzle is not complete.
            submitMessage = "The puzzle is not complete. Keep trying!"
        }
    }
}

extension GameView {
    // Adding the Submit button action to the view.
    // You could alternatively place this function elsewhere if desired.
    func submitAction() -> some View {
        Button("Submit") {
            submitPuzzle()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}

struct TileView: View {
    var tile: Tile
    @State private var dragOffset = CGSize.zero

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
        .offset(dragOffset)
        .animation(.easeInOut, value: dragOffset)
    }
}




struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
