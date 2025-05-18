//
//  SavedGeneration.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 15/02/25.
//

import Foundation
import SwiftData

@Model
final class SavedGeneration {
    var prompt: String
    var model: String
    var resolution: String
    var numberOfImages: Int
    var images: [SavedImage]
    var createdAt: Date
    
    init(
        prompt: String,
        model: String,
        resolution: String,
        numberOfImages: Int,
        images: [SavedImage],
        createdAt: Date = .now
    ) {
        self.prompt = prompt
        self.model = model
        self.resolution = resolution
        self.numberOfImages = numberOfImages
        self.images = images
        self.createdAt = createdAt
    }
}

@Model
final class SavedImage {
    var url: String
    var revisedPrompt: String?
    var localImagePath: String
    
    init(url: String, revisedPrompt: String?, localImagePath: String) {
        self.url = url
        self.revisedPrompt = revisedPrompt
        self.localImagePath = localImagePath
    }
}
