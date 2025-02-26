
# Memory Mosaic

**Memory Mosaic** is a SwiftUI puzzle game where each row of tiles is mirrored across a vertical axis. Flip and match mirror images, drag and drop them into their correct positions, and race against the clock to complete the puzzle!

## Gameplay Video

**Link**: https://drive.google.com/file/d/1WqMQSlXrFUw-0mS47fsKYqfKGW4A8JZs/view?usp=sharing

## Gameplay

- **Flip & Match Mechanic**:
    Tap a face-down tile to flip it. Find its mirror image and match it. If correctly matched, both tiles remain flipped. Otherwise, they reset.
- **Drag & Drop Rearrangement**:
  Move matched tiles into their correct positions in the puzzle grid.
- **Timer**:
  You have 2 minutes to solve the puzzle
- **Global Mute Button**:
  Toggle background music on/off at any time.
- **Tutorial**:
  Step-by-step instructions for new players
                                    

## Features
- Typewriter style animation for app title, and bouncing animation for buttons.
- Automated splitting of image and shuffling of image tiles based on difficulty.
- Simulated game functions in tutorial with visuals for easy understanding.
- Custom puzzle shaped buttons with sound effects for enhanced interaction.
- AVFoundation framework for background music and sound effects.
                                

## Requirements

- **iOS 15.0+** or **iPadOS 15.0+**
- **Swift 5.5+**
- **Xcode 13+** or **Swift Playgrounds 4+**

## Installation & Setup

1. **Clone** or **download** this repository.
2. **Open** the project in Xcode (or Swift Playgrounds if you have a `.swiftpm` version).
3. **Build and run** on the simulator or a physical device.
4. If using Swift Playgrounds, open the `.swiftpm` and tap **Run**.

                                    
## App Structure
                                    
- **HomeView.swift**: Main menu (Play, Instructions).
- **GameView.swift**: Puzzle logic (flipping, timer, drag/drop).
- **DifficultyView.swift**: Difficulty selection.
- **ImageView.swift**: Image selection.
- **ToastView.swift**: Pop up message for unsolved puzzle.
- **ScoreboardView.swift**: Displays final score and puzzle reassembly animation.
- **TutorialView.swift**: Explains the vertical mirror logic and gameplay tips.
- **TutorialPair.swift**: Shows a simulation of matching mirror images for beginners.
- **TutorialDragDrop.swift**: Explains drag & drop principle for completing the puzzle.

## Contributing

1. **Fork** the repository.
2. Create a **feature branch** (`git checkout -b feature/my-feature`).
3. **Commit** your changes.
4. **Push** to your branch (`git push origin feature/my-feature`).
5. **Open a Pull Request** describing your changes.




