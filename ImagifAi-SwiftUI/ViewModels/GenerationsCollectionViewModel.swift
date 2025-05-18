//
//  GenerationsCollectionViewModel.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 15/02/25.
//

import Foundation
import SwiftData

@Observable
final class GenerationsCollectionViewModel {
    var savedGenerations: [SavedGeneration] = []
    
    func loadSavedGenerations(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<SavedGeneration>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        do {
            savedGenerations = try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching saved generations: \(error)")
        }
    }
}
