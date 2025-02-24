//
//  ImageSplit.swift
//  Memory Tiles
//
//  Created by adi on 2/16/25.
//

import SwiftUI

func splitImage(imageName: String, gridSize: Int) -> [UIImage]? {
    guard let image = UIImage(named: imageName),
          let cgImage = image.cgImage else { return nil }
    
    let imageWidth = CGFloat(cgImage.width)
    let imageHeight = CGFloat(cgImage.height)
    
    let tileWidth = imageWidth / CGFloat(gridSize)
    let tileHeight = imageHeight / CGFloat(gridSize)
    
    var tiles: [UIImage] = []
    
    for row in 0..<gridSize {
        for col in 0..<gridSize {
            let rect = CGRect(x: CGFloat(col) * tileWidth,
                              y: CGFloat(row) * tileHeight,
                              width: tileWidth,
                              height: tileHeight)
            if let croppedCGImage = cgImage.cropping(to: rect) {
                let tileImage = UIImage(cgImage: croppedCGImage,
                                        scale: image.scale,
                                        orientation: image.imageOrientation)
                tiles.append(tileImage)
            }
        }
    }
    
    return tiles.count == gridSize * gridSize ? tiles : nil
}


