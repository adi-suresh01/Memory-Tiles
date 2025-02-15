//
//  Memory_TilesApp.swift
//  Memory Tiles
//
//  Created by adi on 2/14/25.
//

import SwiftUI

@main
struct Memory_TilesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
