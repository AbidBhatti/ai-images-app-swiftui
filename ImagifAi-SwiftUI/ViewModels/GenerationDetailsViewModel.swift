//
//  GenerationDetailsViewModel.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 15/02/25.
//

import SwiftUI
import SwiftData
import ABNetworking

@MainActor
class GenerationDetailsViewModel: ObservableObject {
    enum ViewState {
        case idle
        case loading
        case loaded(imageResponse: ImageResponse)
        case error(errorString: String)
    }
    
    @Published var state: ViewState = .idle
    @Published var selectedImageURL: URL?
    @Published var showPhotoLibraryAccessAlert = false
    @Published var showSuccessAlert = false
    @Published var showErrorAlert = false
    @Published var errorMessage: String?
    @Published var isSaving = false
    
    private let mode: GenerationDetailsView.ViewMode
    private let openAIService: OpenAIService
    private var userInputData: ImageGenerationUserInput?
    private var savedGeneration: SavedGeneration?
    
    private var downloadedImagePaths: [String: String] = [:]
    
    private let imageSaver = ImageSaver()
    
    var navigationTitle: String {
        switch mode {
        case .apiResult: return "Generation Result"
        case .savedGeneration: return "Saved Generation"
        }
    }
    
    var aspectRatio: CGFloat {
        switch mode {
        case .apiResult(let input):
            let size = input.selectedResolution.size
            return size.width / size.height
        case .savedGeneration(let generation):
            let components = generation.resolution.split(separator: "x")
            guard components.count == 2,
                  let width = Float(components[0]),
                  let height = Float(components[1]) else {
                return 1.0
            }
            return CGFloat(width / height)
        }
    }
    
    var imageURLs: [URL] {
        switch mode {
        case .apiResult:
            if case .loaded(let response) = state {
                return response.data.compactMap { URL(string: $0.url) }
            }
            return []
        case .savedGeneration(let generation):
            return generation.images.compactMap { getImageURL(path: $0.localImagePath) }
        }
    }
    
    var hasMultipleImages: Bool {
        imageURLs.count > 1
    }
    
    // Metadata properties
    var prompt: String {
        switch mode {
        case .apiResult(let input): return input.prompt
        case .savedGeneration(let generation): return generation.prompt
        }
    }
    
    var model: String {
        switch mode {
        case .apiResult(let input): return input.selectedModel.rawValue
        case .savedGeneration(let generation): return generation.model
        }
    }
    
    var resolution: String {
        switch mode {
        case .apiResult(let input): return input.selectedResolution.string
        case .savedGeneration(let generation): return generation.resolution
        }
    }
    
    var numberOfImages: Int {
        switch mode {
        case .apiResult(let input): return input.numberOfImages
        case .savedGeneration(let generation): return generation.numberOfImages
        }
    }
    
    var revisedPrompt: String? {
        switch mode {
        case .apiResult:
            if case .loaded(let response) = state,
               let firstImage = response.data.first {
                return firstImage.revisedPrompt
            }
            return nil
        case .savedGeneration(let generation):
            if let selectedURL = selectedImageURL,
               let image = generation.images.first(where: { getImageURL(path: $0.localImagePath) == selectedURL }) {
                return image.revisedPrompt
            }
            return nil
        }
    }
    
    init(input: ImageGenerationUserInput) {
        self.mode = .apiResult(input)
        self.userInputData = input
        self.openAIService = OpenAIService()
    }
    
    init(savedGeneration: SavedGeneration) {
        self.mode = .savedGeneration(savedGeneration)
        self.savedGeneration = savedGeneration
        self.openAIService = OpenAIService()
        if let firstImagePath = savedGeneration.images.first?.localImagePath {
            self.selectedImageURL = getImageURL(path: firstImagePath)
        }
    }
    
    func onAppear() {
        if case .apiResult = mode {
            generateImages()
        }
    }
    
    private func generateImages() {
        guard case .apiResult(let input) = mode else { return }
        
        Task {
            state = .loading
            let imageEndpoint = OpenAIEndpoint.imagesGeneration(input)
            do {
                let imageResponse = try await openAIService.generateImage(from: imageEndpoint)
                
                // Save images as they are downloaded
                let imageSaver = ImageSaver()
                for imageData in imageResponse.data {
                    if let localPath = try? await imageSaver.saveImage(from: imageData.url) {
                        downloadedImagePaths[imageData.url] = localPath
                    }
                }
                
                state = .loaded(imageResponse: imageResponse)
                if let firstImageURL = imageResponse.data.first?.url {
                    selectedImageURL = URL(string: firstImageURL)
                }
            } catch let error as APIClientError {
                state = .error(errorString: error.message)
            }
        }
    }
    
    func saveGeneration(modelContext: ModelContext) async {
        guard case .loaded(let imageResponse) = state,
              case .apiResult(let input) = mode else { return }
        
        await MainActor.run {
            isSaving = true
        }
        
        do {
            // Create saved images using already downloaded files
            let savedImages = imageResponse.data.compactMap { imageData -> SavedImage? in
                guard let localPath = downloadedImagePaths[imageData.url] else { return nil }
                return SavedImage(
                    url: imageData.url,
                    revisedPrompt: imageData.revisedPrompt,
                    localImagePath: localPath
                )
            }
            
            // Create and save the generation
            try await MainActor.run {
                let savedGeneration = SavedGeneration(
                    prompt: input.prompt,
                    model: input.selectedModel.rawValue,
                    resolution: input.selectedResolution.string,
                    numberOfImages: input.numberOfImages,
                    images: savedImages
                )
                
                modelContext.insert(savedGeneration)
                try modelContext.save()
                isSaving = false
                showSuccessAlert = true
            }
        } catch {
            await MainActor.run {
                isSaving = false
                errorMessage = error.localizedDescription
                showErrorAlert = true
            }
        }
    }
    
    func saveToGallery() async {
        guard case .savedGeneration(let generation) = mode else { return }
        
        do {
            for image in generation.images {
                try await imageSaver.saveToPhotoLibrary(localPath: image.localImagePath)
            }
            showSuccessAlert = true
        } catch ImageSaver.ImageSaverError.photoLibraryAccessDenied {
            showPhotoLibraryAccessAlert = true
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
    
    private func getImageURL(path: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(path)
    }
    
    func deleteGeneration(modelContext: ModelContext) {
        guard case .savedGeneration(let generation) = mode else { return }
        
        // Delete local image files
        for image in generation.images {
            let fileURL = getImageURL(path: image.localImagePath)
            try? FileManager.default.removeItem(at: fileURL)
        }
        
        // Delete from SwiftData
        modelContext.delete(generation)
        try? modelContext.save()
    }
    
    func calculateContentHeight() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let imageWidth = screenWidth * 0.6
        let imageHeight = imageWidth / aspectRatio
        
        let totalHeight = hasMultipleImages ?
            imageHeight + 140 :
            imageHeight + 20
        
        return totalHeight
    }
    
    func onDisappear() {
        Task {
            // Remove all cached images except those that were saved
            let urlsToKeep = Set(downloadedImagePaths.keys.compactMap { URL(string: $0) })
            await ImageCache.shared.removeAllExcept(urls: Array(urlsToKeep))
        }
    }
}
