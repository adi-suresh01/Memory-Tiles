//
//  Tile.swift
//  Memory Tiles
//
//  Created by adi on 2/16/25.
//

import Foundation
import SwiftUI

struct Tile: Identifiable {
    let id = UUID()
    let image: UIImage
    let correctRow: Int  // Original row position
    let correctCol: Int  // Original column position
    var currentRow: Int  // Current row position in the grid
    var currentCol: Int  // Current col position in the grid
    var isFlipped: Bool = false
    var isMatched: Bool = false
    var isPlaceholder: Bool = false
//    var isLocked: Bool = false
}

