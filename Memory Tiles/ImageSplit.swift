//
//  ImageSplit.swift
//  Memory Tiles
//
//  Created by adi on 2/16/25.
//

import SwiftUI

func splitImage(imageName: String, gridSize: Int) -> [UIImage]? {
    guard let image = UIImage(named: imageName) else { return nil }
    
    let tileSize = image.size.width / CGFloat(gridSize) // Assume square image
    var tiles: [UIImage] = []

    for row in 0..<gridSize {
        for col in 0..<gridSize {
            let rect = CGRect(x: CGFloat(col) * tileSize, y: CGFloat(row) * tileSize, width: tileSize, height: tileSize)
            if let croppedCGImage = image.cgImage?.cropping(to: rect) {
                tiles.append(UIImage(cgImage: croppedCGImage))
            }
        }
    }

    return tiles.count == gridSize * gridSize ? tiles : nil
}

