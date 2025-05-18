//
//  GenerationDetailsView.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 15/02/25.
//

import SwiftUI
import Photos
import SwiftData

struct GenerationDetailsView: View {
    enum ViewMode {
        case apiResult(ImageGenerationUserInput)
        case savedGeneration(SavedGeneration)
    }
    
    typealias GlobalStrings = Constants.GlobalStrings
    typealias ViewStrings = Constants.GenerationDetailsView.Strings
    
    private let mode: ViewMode
    
    @StateObject private var viewModel: GenerationDetailsViewModel
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    init(mode: ViewMode) {
        self.mode = mode
        let vm: GenerationDetailsViewModel
        switch mode {
        case .apiResult(let input):
            vm = GenerationDetailsViewModel(input: input)
        case .savedGeneration(let generation):
            vm = GenerationDetailsViewModel(savedGeneration: generation)
        }
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                content
                
                actionButtons
                    .padding(.horizontal)
                
                metadataView
            }
            .padding(.top)
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarVisibility(.hidden, for: .tabBar)
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
        .alert(ViewStrings.photoLibraryAccess, isPresented: $viewModel.showPhotoLibraryAccessAlert) {
            Button(GlobalStrings.settings, role: .none) {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
            Button(GlobalStrings.cancel, role: .cancel) {}
        }
        .alert(GlobalStrings.success, isPresented: $viewModel.showSuccessAlert) {
            Button(GlobalStrings.ok, role: .cancel) {}
        } message: {
            switch mode {
            case .apiResult:
                Text(ViewStrings.imageSavedToLocalStorage)
            case .savedGeneration:
                Text(ViewStrings.imageSavedToPhotoLibrary)
            }
        }
        .alert(GlobalStrings.error, isPresented: $viewModel.showErrorAlert) {
            Button(GlobalStrings.ok, role: .cancel) {}
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

private extension GenerationDetailsView {
    
    var content: some View {
        GeometryReader { proxy in
            if case .loading = viewModel.state {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            ProgressView()
                            Text(ViewStrings.generatingImages)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    Spacer()
                }
            } else {
                let imageWidth = proxy.size.width * 0.6
                let imageHeight = imageWidth / viewModel.aspectRatio
                
                VStack(spacing: 20) {
                    mainImageView(width: imageWidth, height: imageHeight)
                    
                    if viewModel.hasMultipleImages {
                        imageList
                    }
                }
            }
        }
        .frame(height: viewModel.calculateContentHeight())
    }
    
    func mainImageView(width: CGFloat, height: CGFloat) -> some View {
        HStack {
            Spacer()
            if let imageURL = viewModel.selectedImageURL {
                CachedAsyncImage(
                    url: imageURL,
                    content: { image in
                        image
                            .resizable()
                            .scaledToFit()
                    },
                    placeholder: {
                        ProgressView()
                    }
                )
                .id(imageURL)
                .frame(width: width, height: height)
                .cornerRadius(12)
            }
            Spacer()
        }
    }
    
    
    var imageList: some View {
        let thumbnailSize = CGSize(width: 100, height: 100 * viewModel.aspectRatio)
        
        return GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 12) {
                    Spacer()
                    ForEach(viewModel.imageURLs, id: \.self) { imageURL in
                        CachedAsyncImage(
                            url: imageURL,
                            content: { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            },
                            placeholder: {
                                ProgressView()
                                    .frame(width: thumbnailSize.width, height: thumbnailSize.height)
                            }
                        )
                        .id(imageURL)
                        .frame(width: thumbnailSize.width, height: thumbnailSize.height)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .opacity(imageURL == viewModel.selectedImageURL ? 1.0 : 0.5)
                        .onTapGesture {
                            withAnimation {
                                viewModel.selectedImageURL = imageURL
                            }
                        }
                    }
                    Spacer()
                }
                .frame(width: proxy.size.width)
            }
        }
    }
    
    var metadataView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Prompt: \(viewModel.prompt)")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(nil)
            
            if let revisedPrompt = viewModel.revisedPrompt {
                Text("Revised Prompt: \(revisedPrompt)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
            }
            
            Text("Model: \(viewModel.model)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Resolution: \(viewModel.resolution)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Number of images: \(viewModel.numberOfImages)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var actionButtons: some View {
        HStack(spacing: 20) {
            switch mode {
            case .apiResult:
                Button {
                    Task {
                        await viewModel.saveGeneration(modelContext: modelContext)
                    }
                } label: {
                    if viewModel.isSaving {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text(ViewStrings.saveToCollections)
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isSaving)
                
            case .savedGeneration:
                Button {
                    Task {
                        await viewModel.saveToGallery()
                    }
                } label: {
                    Text(ViewStrings.saveToGallery)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                Button(role: .destructive) {
                    viewModel.deleteGeneration(modelContext: modelContext)
                    dismiss()
                } label: {
                    Text(GlobalStrings.delete)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

#Preview {
    GenerationDetailsView(mode: .apiResult(ImageGenerationUserInput()))
}

