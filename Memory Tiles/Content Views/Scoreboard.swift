//
//  Scoreboard.swift
//  Memory Tiles
//
//  Created by adi on 2/21/25.
//

import SwiftUI

struct ScoreboardView: View {
    let finalScore: Int
    let onClose: () -> Void  // A callback to dismiss GameView
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .offset(x: 0, y: 0)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Text("Good job!")
                    .font(.custom("Chalkboard SE", size: 50))
                    .foregroundColor(Color(red: 245/255, green: 215/255, blue: 135/255))
                    .padding(.top, 50)
                
                Text("Your final score: \(finalScore)")
                    .font(.custom("Chalkboard SE", size: 40))
                    .foregroundColor(.green)
                    .padding()
                
                Button(action: {
                    // Call the callback passed from GameView
                    onClose()
                }) {
                    Text("Close")
                        .font(.custom("Chalkboard SE", size: 30))
                        .foregroundColor(Color(red: 245/255, green: 215/255, blue: 135/255))
                }
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
            .padding()
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
