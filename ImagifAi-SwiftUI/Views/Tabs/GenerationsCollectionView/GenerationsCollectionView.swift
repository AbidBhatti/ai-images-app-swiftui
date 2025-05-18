//
//  GenerationsCollectionView.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 15/12/24.
//

import SwiftUI
import SwiftData

struct GenerationsCollectionView: View {
    
    typealias ViewStrings = Constants.GenerationsCollectionView.Strings
    
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = GenerationsCollectionViewModel()
    @State private var isLoading = true
    
    private var itemWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 16
        let horizontalPadding: CGFloat = 16 * 2
        return (screenWidth - spacing - horizontalPadding) / 2
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                generationCollection
                
                if isLoading {
                    ProgressView()
                }
            }
            .navigationTitle(ViewStrings.savedGenerations)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.loadSavedGenerations(modelContext: modelContext)
            // Simulate loading time for images
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isLoading = false
            }
        }
    }
}

// MARK: - Private Views
private extension GenerationsCollectionView {
    var generationCollection: some View {
        ScrollView {
            MasonryLayout(spacing: 16, columns: 2) {
                ForEach(viewModel.savedGenerations) { generation in
                    GenerationItem(generation: generation, width: itemWidth)
                        .redacted(reason: isLoading ? .placeholder : [])
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
        }
    }
}
    

#Preview {
    GenerationsCollectionView()
}
