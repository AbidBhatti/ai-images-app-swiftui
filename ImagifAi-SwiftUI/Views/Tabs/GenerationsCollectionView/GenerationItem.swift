//
//  GenerationItem.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 15/02/25.
//

import SwiftUI

struct GenerationItem: View {
    
    typealias ViewImagesConstants = Constants.GenerationsCollectionView.Images
    
    let generation: SavedGeneration
    let width: CGFloat
    
    var body: some View {
        NavigationLink(destination: GenerationDetailsView(mode: .savedGeneration(generation))) {
            if let firstImage = generation.images.first {
                AsyncImage(url: getImageURL(path: firstImage.localImagePath)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: width)
                    case .failure:
                        Image(systemName: ViewImagesConstants.photo)
                            .foregroundStyle(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
            }
        }
    }
    
    private func getImageURL(path: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(path)
    }
}
