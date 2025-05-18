//
//  GenerateImageViewModel.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 18/12/24.
//

import Foundation

@Observable
final class GenerateImageViewModel {
    var userInputData = ImageGenerationUserInput()
    var showInvalidInputAlert: Bool = false
    var presentImageResult: Bool = false
    var maxNumberOfImages: Int {
        return userInputData.selectedModel == .dalle2 ? 3 : 1
    }
    
    init(userInputData: ImageGenerationUserInput = ImageGenerationUserInput()) {
        self.userInputData = userInputData
    }
    
    func generateImage() {
        guard validateUserInputData() else {
            showInvalidInputAlert = true
            return
        }
        presentImageResult = true
    }
    
    func resetData() {
        userInputData = ImageGenerationUserInput()
    }
    
    func modelUpdated() {
        
        let model = userInputData.selectedModel
        
        /// dall-e-3 supports only single image,
        /// so numberOfImages needs to be updated if the model is updated
        if model == .dalle3,
           userInputData.numberOfImages > 1 {
            userInputData.numberOfImages = 1
        }
        
        /// check if the updated model supports the user selected resolution
        /// if not: update the resolution
        guard !model.resolutions.contains(userInputData.selectedResolution) else {
            return
        }
        
        /// if first value doesn't exist (which won't happen though)
        /// set it to large1024x1024, as it is supported by both models
        userInputData.selectedResolution = model.resolutions.first ?? .large1024x1024
    }
    
    private func validateUserInputData() -> Bool {
        return !userInputData.prompt.isEmpty
    }
}
