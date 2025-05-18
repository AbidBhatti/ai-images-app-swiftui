//
//  GenerateImageViewModelTest.swift
//  ImagifAi-SwiftUITests
//
//  Created by Abid Bhatti on 21/12/24.
//

import Testing

@Suite("GenerateImageViewModelTest")
struct GenerateImageViewModelTest {

    @Test("Invalid User Input")
    func invalidUserInput() {
        let viewModel = GenerateImageViewModel()
        
        // try to generate image
        viewModel.generateImage()
        
        #expect(viewModel.showInvalidInputAlert == true, "Should show invalid input Alert, as no prompt is provided")
        #expect(viewModel.presentImageResult == false, "Should not show Image Result View")
    }
    
    @Test("Image Result Is Shown")
    func presentingImageResult() {
        // dummy data
        let userInputData = ImageGenerationUserInput(prompt: "Create a random Image",
                                                     selectedModel: .dalle3,
                                                     selectedResolution: .large1024x1024,
                                                     numberOfImages: 2)
        let viewModel = GenerateImageViewModel(userInputData: userInputData)
        
        // try to generate image
        viewModel.generateImage()
        #expect(viewModel.showInvalidInputAlert == false, "Should not show invalid input Alert, as user input is valid")
        #expect(viewModel.presentImageResult == true, "Should show Image Result View")
    }
    
    @Test("Model Updated to Dall-E-3 With Supported Resolution Selected")
    func modelUpdatedToDalle3WithSupportedResolutionSelected() {
        // dummy data
        let userInputData = ImageGenerationUserInput(prompt: "Create a random Image",
                                                     selectedModel: .dalle2,
                                                     selectedResolution: .large1024x1024,
                                                     numberOfImages: 1)
        let viewModel = GenerateImageViewModel(userInputData: userInputData)
        
        // update model
        viewModel.userInputData.selectedModel = .dalle3
        
        // inform viewModel about the updation
        viewModel.modelUpdated()
        #expect(viewModel.userInputData.selectedResolution == .large1024x1024, "Should not be updated, as large1024x1024 is supported by DALL-E-3")
    }
    
    @Test("Model Updated to Dall-E-3 With Unsupported Resolution Selected")
    func modelUpdatedToDalle3WithUnsupportedResolutionSelected() {
        // dummy data
        let userInputData = ImageGenerationUserInput(prompt: "Create a random Image",
                                                     selectedModel: .dalle2,
                                                     selectedResolution: .small256x256,
                                                     numberOfImages: 1)
        let viewModel = GenerateImageViewModel(userInputData: userInputData)
        
        // update model
        viewModel.userInputData.selectedModel = .dalle3
        
        // inform viewModel about the updation
        viewModel.modelUpdated()
        
        #expect(viewModel.userInputData.selectedResolution == .large1024x1024, "Should be updated, as small256x256 is not supported by Dall-E-3")
        
    }
    
    @Test("Model Updated to Dall-E-2 With Supported Resolution Selected")
    func modelUpdatedToDalle2WithSupportedResolutionSelected() {
        // dummy data
        let userInputData = ImageGenerationUserInput(prompt: "Create a random Image",
                                                     selectedModel: .dalle3,
                                                     selectedResolution: .large1024x1024,
                                                     numberOfImages: 1)
        let viewModel = GenerateImageViewModel(userInputData: userInputData)
        
        // update model
        viewModel.userInputData.selectedModel = .dalle2
        
        // inform viewModel about the updation
        viewModel.modelUpdated()
        
        #expect(viewModel.userInputData.selectedResolution == .large1024x1024, "Should not be updated, as large1024x1024 is supported by Dall-E-2")
    }
    
    @Test("Model Updated to Dall-E-2 With Unsupported Resolution Selected")
    func modelUpdatedToDalle2WithUnsupportedResolutionSelected() {
        // dummy data
        let userInputData = ImageGenerationUserInput(prompt: "Create a random Image",
                                                     selectedModel: .dalle3,
                                                     selectedResolution: .portrait1024x1792,
                                                     numberOfImages: 1)
        let viewModel = GenerateImageViewModel(userInputData: userInputData)
        
        // update model
        viewModel.userInputData.selectedModel = .dalle2
        
        // inform viewModel about the updation
        viewModel.modelUpdated()
        
        #expect(viewModel.userInputData.selectedResolution == .small256x256, "Should be updated, as portrait1024x1792 is not supported by Dall-E-2")
    }
    
    @Test("Model Updated to Dall-E-3 With Unsupported Number of Images")
    func modelUpdatedToDalle3WithUnsupportedNumberOfImages() {
        // dummy data
        let userInputData = ImageGenerationUserInput(prompt: "Create a random Image",
                                                     selectedModel: .dalle2,
                                                     selectedResolution: .large1024x1024,
                                                     numberOfImages: 3)
        let viewModel = GenerateImageViewModel(userInputData: userInputData)
        
        // update model
        viewModel.userInputData.selectedModel = .dalle3
        
        // inform viewModel about the updation
        viewModel.modelUpdated()
        
        #expect(viewModel.userInputData.numberOfImages == 1, "Should not be updated, as Dall-E-2 supports only single image")
    }
    
    @Test("User Input Has Reset")
    func resetUserInput() {
        // dummy data
        let userInputData = ImageGenerationUserInput(prompt: "Create a random Image",
                                                     selectedModel: .dalle3,
                                                     selectedResolution: .large1024x1024,
                                                     numberOfImages: 2)
        let viewModel = GenerateImageViewModel(userInputData: userInputData)
        
        // initial expectations
        #expect(!viewModel.userInputData.prompt.isEmpty)
        #expect(viewModel.userInputData.selectedModel == .dalle3)
        #expect(viewModel.userInputData.selectedResolution == .large1024x1024)
        #expect(viewModel.userInputData.numberOfImages == 2)
        
        // reset user data
        viewModel.resetData()
        
        // after reset expectations
        #expect(viewModel.userInputData.prompt.isEmpty)
        #expect(viewModel.userInputData.selectedModel == .dalle2)
        #expect(viewModel.userInputData.selectedResolution == .large1024x1024)
        #expect(viewModel.userInputData.numberOfImages == 1)
    }

}
