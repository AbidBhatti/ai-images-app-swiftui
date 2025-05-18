//
//  ImagifAi_SwiftUIApp.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 14/12/24.
//

import SwiftUI
import SwiftData

@main
struct ImagifAi_SwiftUIApp: App {
    
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: SavedGeneration.self, SavedImage.self)
        } catch {
            fatalError("Failed to initialize ModelContainer")
        }
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
