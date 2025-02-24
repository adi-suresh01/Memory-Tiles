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
    @State private var tiles: [[Tile]] = []
    @State private var selectedTiles: [Tile] = []
    @State private var showWinMessage = false

    @State private var timeRemaining = 120
    @State private var timer: Timer? = nil
    @State private var showGameOver = false
    @State private var showScoreboard = false
    @State private var finalScore = 0
    @State private var toastMessage: String = ""
    @State private var toastMessageID: Int = 0

    // Gather puzzle tiles as UIImage array in row-major order.
    private var finalPuzzleTiles: [UIImage] {
        var images: [UIImage] = []
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                images.append(tiles[row][col].image)
            }
        }
        return images
    }

    // The entire puzzle image (original)
    var puzzleImage: UIImage {
        UIImage(named: selectedImage) ?? UIImage()
    }

    // Format time as mm:ss
    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Decide tile size for the puzzle grid
    var computedTileSize: CGFloat {
        switch gridSize {
        case 4:
            return 80
        case 6:
            return 50
        default:
            return 60
        }
    }

    var body: some View {
        ZStack {
            // Background
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            // Main game layout
            VStack(spacing: 16) {
                // Title
                Text("Memory Mosaic")
                    .font(.custom("Chalkboard SE", size: 30))
                    .foregroundColor(Color(red: 245/255, green: 215/255, blue: 135/255))
                    .padding(.top, -50)

                // Time left
                if timeRemaining > 60 {
                    Text("Time Left: \(formattedTime)")
                        .font(.custom("Chalkboard SE", size: 40))
                        .foregroundColor(.green)
                        .offset(x: 0, y: -20)
                } else {
                    Text("Time Left: \(formattedTime)")
                        .font(.custom("Chalkboard SE", size: 30))
                        .foregroundColor(.red)
                }

                // Puzzle grid or loading
                if tiles.isEmpty {
                    ProgressView("Loading Tiles...")
                } else {
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
                                        // Drag only if flipped & not matched
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
                    .offset(x: 0, y: -20)
                }

                // Reference image
                VStack {
                    Image(selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .cornerRadius(8)
                }
                .padding(.top)
                .offset(x: 0, y: -35)

                // Finish button
                Button {
                    submitPuzzle()
                } label: {
                    Text("Finish")
                        .font(.custom("Chalkboard SE", size: 30))
                        .foregroundColor(Color(red: 245/255, green: 215/255, blue: 135/255))
                }
                .simultaneousGesture(TapGesture().onEnded {
                    AudioManager.shared.playSFX("click")
                })
                .buttonStyle(
                    PuzzleButtonStyle(
                        backgroundColor: .blue.opacity(0.8),
                        cornerRadius: 0,
                        arcRadius: 25,
                        caveDepth: 36,
                        protrusionDepth: 36
                    )
                )
                .offset(x: 0, y: -30)

                // Win message if puzzle is matched
                if showWinMessage {
                    Text("You Win!")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding()
                }
            }

            // Toast overlay (if any)
            if !toastMessage.isEmpty {
                ToastView(message: toastMessage) {
                    toastMessage = ""
                }
                .id(toastMessageID)
                .transition(.move(edge: .bottom))
                .zIndex(1)
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
        .sheet(isPresented: $showScoreboard) {
            ScoreboardView(
                finalScore: finalScore,
                onClose: {
                    showScoreboard = false
                    dismiss()
                },
                tileImages: finalPuzzleTiles,
                finalImage: puzzleImage
            )
        }
    }

    // MARK: - Timer Logic
    private func startTimer() {
        timer?.invalidate()
        timeRemaining = 120
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
        showWinMessage = false
        setupGame()
        startTimer()
    }

    private func goHome() {
        dismiss()
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
                rowTiles.append(tile)
            }
            newGrid.append(rowTiles)
        }
        self.tiles = newGrid
    }

    // MARK: - Memory Phase
    private func handleTileTap(atRow row: Int, col: Int) {
        var tile = tiles[row][col]
        if tile.isFlipped || tile.isMatched { return }

        // Flip sound
        AudioManager.shared.playSFX("flip2")

        tile.isFlipped = true
        updateTile(tile, atRow: row, col: col)
        selectedTiles.append(tile)

        if selectedTiles.count == 2 {
            let first = selectedTiles[0]
            let second = selectedTiles[1]
            if isCorrectPair(first, second) {
                // remain flipped
            } else {
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

    // For vertical mirror logic
    private func isCorrectPair(_ first: Tile, _ second: Tile) -> Bool {
        // same row, col1 + col2 = gridSize - 1
        return (first.correctRow == second.correctRow)
            && (first.correctCol + second.correctCol == gridSize - 1)
    }

    // MARK: - Drag and Drop
    func handleDrop(draggedTileId: UUID, targetRow: Int, targetCol: Int) {
        guard let sourcePos = findTilePosition(by: draggedTileId) else { return }
        let sourceRow = sourcePos.row
        let sourceCol = sourcePos.col

        if sourceRow == targetRow && sourceCol == targetCol { return }

        var draggedTile = tiles[sourceRow][sourceCol]
        let targetTile = tiles[targetRow][targetCol]

        if !draggedTile.isFlipped || draggedTile.isMatched { return }
        if targetTile.isMatched { return }

        draggedTile.currentRow = targetRow
        draggedTile.currentCol = targetCol

        var newTargetTile = targetTile
        newTargetTile.currentRow = sourceRow
        newTargetTile.currentCol = sourceCol

        tiles[targetRow][targetCol] = draggedTile
        tiles[sourceRow][sourceCol] = newTargetTile

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
            timer?.invalidate()
            finalScore = 4 * timeRemaining
            showScoreboard = true
        } else {
            // Instead of shifting layout, show a toast
            toastMessage = "The puzzle is not complete. Keep trying!"
            toastMessageID += 1
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
    var tileSize: CGFloat
    @State private var dragOffset = CGSize.zero

    var body: some View {
        ZStack {
            if tile.isFlipped || tile.isMatched {
                Image(uiImage: tile.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: tileSize, height: tileSize)
                    .opacity(1)
            } else {
                Rectangle()
                    .fill(Color(red: 245/255, green: 215/255, blue: 135/255))
                Text("?")
                    .font(.system(size: tileSize * 0.6, weight: .bold))
                    .foregroundColor(.black)
                    .frame(width: tileSize, height: tileSize)
                    .opacity(1)
            }
        }
//        .rotation3DEffect(.degrees(180), axis: (x: 0, y: -1, z: 0), anchor: .center, anchorZ: 0, perspective: 0.8)
        .offset(dragOffset)
        .animation(.easeInOut(duration: 0.45), value: tile.isMatched)
        .animation(.easeInOut(duration: 0.45), value: tile.isFlipped)
        .animation(.easeInOut, value: dragOffset)
    }
}




struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
