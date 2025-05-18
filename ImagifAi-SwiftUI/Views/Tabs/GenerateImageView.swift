//
//  GenerateImageView.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 15/12/24.
//

import SwiftUI

struct GenerateImageView: View {
    
    typealias ViewStrings = Constants.GenerateImageView.Strings
    typealias GlobalStrings = Constants.GlobalStrings
    @FocusState private var isPromptFocused: Bool
    @Bindable private var viewModel = GenerateImageViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                promptView
                
                modelView
                
                resolutionView
                
                numberOfImagesView
                
                generateButton
            }
            .navigationTitle(ViewStrings.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $viewModel.presentImageResult) {
                GenerationDetailsView(mode: .apiResult(viewModel.userInputData))
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(GlobalStrings.reset) {
                        isPromptFocused = false
                        viewModel.resetData()
                    }
                }
            }
            .alert(ViewStrings.emptyPrompt, isPresented: $viewModel.showInvalidInputAlert) {
                Button(GlobalStrings.ok, role: .cancel) {
                    // not required, as role is defined
                }
            }
            .onChange(of: viewModel.userInputData.selectedModel) {
                /// inform viewModel about model updations
                /// so that resolution and number of images can be updated if required
                viewModel.modelUpdated()
            }
        }
    }
}

// MARK: - Private Views
private extension GenerateImageView {
    
    var promptView: some View {
        VStack(alignment: .leading) {
            Text(ViewStrings.prompt)
                .font(.headline)
            TextField(ViewStrings.promptTextfieldPlaceholder, text: $viewModel.userInputData.prompt, axis: .vertical)
                .focused($isPromptFocused)
                .padding(.horizontal, 6)
                .padding(.vertical, 14)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.primary.opacity(0.08))
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button(GlobalStrings.done) {
                            isPromptFocused = false
                        }
                    }
                }
        }
        .padding(.vertical, 8)
    }
    
    var modelView: some View {
        VStack(alignment: .leading) {
            Text(ViewStrings.model)
                .font(.headline)
            Picker(selection: $viewModel.userInputData.selectedModel) {
                ForEach(ChatGPTModel.allCases, id: \.name) { model in
                    Text(model.name)
                        .tag(model)
                }
            } label: {
                // left empty, as the upper header text will work
            }
            .pickerStyle(.segmented)
        }
        .padding(.vertical, 8)
    }
    
    var resolutionView: some View {
        VStack(alignment: .leading) {
            Picker(selection: $viewModel.userInputData.selectedResolution) {
                ForEach(viewModel.userInputData.selectedModel.resolutions, id: \.string) { resolution in
                    Text(resolution.string)
                        .tag(resolution)
                }
            } label: {
                Text(ViewStrings.resolution)
                    .font(.headline)
            }
            .pickerStyle(.menu)
        }
        .padding(.vertical, 8)
    }
    
    var numberOfImagesView: some View {
        VStack(alignment: .leading) {
            Text(ViewStrings.numberOfImages)
                .font(.headline)
            Stepper(value: $viewModel.userInputData.numberOfImages, in: 1...viewModel.maxNumberOfImages) {
                Text("\(viewModel.userInputData.numberOfImages)")
            }
        }
        .padding(.vertical, 8)
    }
    
    var generateButton: some View {
        HStack {
            Spacer()
            Button(ViewStrings.generate) {
                viewModel.generateImage()
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding(.vertical)
    }
}

#Preview {
    GenerateImageView()
}
