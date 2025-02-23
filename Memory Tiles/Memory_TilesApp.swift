//
//  Memory_TilesApp.swift
//  Memory Tiles
//
//  Created by adi on 2/14/25.
//

import SwiftUI

@main
struct Memory_TilesApp: App {
    init() {
            AudioManager.shared.playBackgroundMusic()
        }
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

