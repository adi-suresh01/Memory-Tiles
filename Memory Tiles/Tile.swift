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
    let row: Int
    let col: Int
    var isFlipped: Bool = false
    var isMatched: Bool = false
}

