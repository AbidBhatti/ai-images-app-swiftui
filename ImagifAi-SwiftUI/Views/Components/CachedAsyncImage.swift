//
//  CachedAsyncImage.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 15/02/25.
//

import SwiftUI
import UIKit

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    private let url: URL
    private let scale: CGFloat
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    @State private var phase: AsyncImagePhase = .empty
    
    init(
        url: URL,
        scale: CGFloat = 1.0,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.scale = scale
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            switch phase {
            case .empty:
                placeholder()
                    .task {
                        await loadImage()
                    }
            case .success(let image):
                content(image)
            case .failure:
                Text("Failed to load image")
                    .foregroundColor(.gray)
            @unknown default:
                placeholder()
            }
        }
    }
    
    private func loadImage() async {
        // First check memory cache
        if let cachedImage = await ImageCache.shared.get(url) {
            phase = .success(Image(uiImage: cachedImage))
            return
        }
        
        // Then check if it's a local file URL
        if url.isFileURL {
            do {
                let data = try Data(contentsOf: url)
                guard let uiImage = UIImage(data: data) else {
                    phase = .failure(URLError(.badServerResponse))
                    return
                }
                await ImageCache.shared.insert(uiImage, for: url)
                phase = .success(Image(uiImage: uiImage))
            } catch {
                phase = .failure(error)
            }
            return
        }
        
        // Finally, download from network
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let uiImage = UIImage(data: data) else {
                phase = .failure(URLError(.badServerResponse))
                return
            }
            
            await ImageCache.shared.insert(uiImage, for: url)
            phase = .success(Image(uiImage: uiImage))
        } catch {
            phase = .failure(error)
        }
    }
}

// Convenience initializer for common use case
extension CachedAsyncImage where Content == Image {
    init(
        url: URL,
        scale: CGFloat = 1.0,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.init(url: url, scale: scale) { image in
            image
                .resizable()
        } placeholder: {
            placeholder()
        }
    }
}

// Helper enum to manage loading states
private enum AsyncImagePhase {
    case empty
    case success(Image)
    case failure(Error)
}
