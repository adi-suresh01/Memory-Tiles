//
//  Scoreboard.swift
//  Memory Tiles
//
//  Created by adi on 2/21/25.
//

import SwiftUI

struct ScoreboardView: View {
    let finalScore: Int
    let onClose: () -> Void  // Callback to dismiss
    let tileImages: [UIImage] // 16 tile images for 4×4
    let finalImage: UIImage   // The complete puzzle image
    let gridSize: Int = 4     // For a 4×4 puzzle

    @State private var gridScale: CGFloat = 1.0
    @State private var finalImageScale: CGFloat = 0.0

    var tileSize: CGFloat { 60 }

    var body: some View {
        ZStack {
            // Background
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // Main vertical stack
            VStack(spacing: 20) {
                Spacer().frame(height: 40)

                // 1) Puzzle Assembly (tiles + final image behind)
                ZStack {
                    // The final puzzle image, scaled from 0 -> 1
                    Image(uiImage: finalImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: tileSize * CGFloat(gridSize),
                               height: tileSize * CGFloat(gridSize))
                        .scaleEffect(finalImageScale)

                    // The tile grid, scaled from 1 -> 0
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(tileSize)), count: gridSize), spacing: 0) {
                        ForEach(0..<(gridSize * gridSize), id: \.self) { index in
                            Image(uiImage: tileImages[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: tileSize, height: tileSize)
                        }
                    }
                    .frame(width: tileSize * CGFloat(gridSize),
                           height: tileSize * CGFloat(gridSize))
                    .scaleEffect(gridScale)
                }

                // 2) Score text
                Text("Good job!")
                    .font(.custom("Chalkboard SE", size: 40))
                    .foregroundColor(Color(red: 245/255, green: 215/255, blue: 135/255))

                Text("Your final score: \(finalScore)")
                    .font(.custom("Chalkboard SE", size: 30))
                    .foregroundColor(.green)

                // 3) Close button at bottom
                Button {
                    onClose()
                } label: {
                    Text("Close")
                        .font(.custom("Chalkboard SE", size: 30))
                        .foregroundColor(Color(red: 245/255, green: 215/255, blue: 135/255))
                }
                .simultaneousGesture(TapGesture().onEnded {
                    AudioManager.shared.playSFX("click")
                })
                .padding()
                .buttonStyle(
                    PuzzleButtonStyle(
                        backgroundColor: .blue.opacity(0.8),
                        cornerRadius: 0,
                        arcRadius: 25,
                        caveDepth: 36,
                        protrusionDepth: 36
                    )
                )

                Spacer()
            }
        }
        .onAppear {
            // Animate puzzle tiles to shrink, final image to grow
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 1.5)) {
                    gridScale = 0.0
                    finalImageScale = 1.0
                }
            }
        }
    }
}



//struct ScoreboardView: View {
//    // The final score and difficulty passed from GameView
//    let finalScore: Int
//    let difficulty: String
//
//    // Access the managed object context for saving/fetching
//    @Environment(\.managedObjectContext) private var viewContext
//
//    // A fetch request to load ScoreRecord entities, sorted by score descending
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \ScoreRecord.score, ascending: false)]
//    ) var records: FetchedResults<ScoreRecord>
//
//    // State for user input
//    @State private var playerName: String = ""
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                Text("Puzzle Completed!")
//                    .font(.largeTitle)
//                    .padding(.top)
//
//                // Show final score and difficulty
//                Text("Your Score: \(finalScore)")
//                    .font(.title2)
//                Text("Difficulty: \(difficulty)")
//                    .font(.headline)
//                    .foregroundColor(.secondary)
//
//                // User enters their name
//                TextField("Enter your name", text: $playerName)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.horizontal)
//
//                // Button to save the score
//                Button("Save Score") {
//                    saveScore()
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(8)
//
//                // Divider before the scoreboard list
//                Divider()
//                    .padding(.vertical, 10)
//
//                // List of all saved scores
//                List {
//                    ForEach(records) { record in
//                        HStack {
//                            Text(record.name ?? "Unknown")
//                            Spacer()
//                            Text("\(record.score)")
//                            Spacer()
//                            Text(record.difficulty ?? "N/A")
//                        }
//                    }
//                }
//                .listStyle(PlainListStyle())
//            }
//            .padding()
//            .navigationTitle("Scoreboard")
//        }
//    }
//
//    /// Saves the current player's name, difficulty, and final score to Core Data.
//    private func saveScore() {
//        // Create a new ScoreRecord entity
//        let newRecord = ScoreRecord(context: viewContext)
//        newRecord.name = playerName
//        newRecord.difficulty = difficulty
//        newRecord.score = Int64(finalScore)
//        newRecord.date = Date()  // optional if you want a timestamp
//
//        do {
//            // Persist the new record
//            try viewContext.save()
//            // Clear the player name field after saving
//            playerName = ""
//        } catch {
//            print("Failed to save score: \(error)")
//        }
//    }
//}
