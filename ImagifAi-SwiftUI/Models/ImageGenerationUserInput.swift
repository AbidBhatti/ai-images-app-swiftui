//
//  ImageGenerationUserInput.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 19/12/24.
//

import Foundation

struct ImageGenerationUserInput {
    var prompt: String = ""
    var selectedModel: ChatGPTModel = .dalle2
    var selectedResolution: ImageResolution = .large1024x1024
    var numberOfImages: Int = 1
}


extension ImageGenerationUserInput {
    func encodedData() -> Data? {
        let dict: [String: Any] = [
            "model": selectedModel.rawValue,
            "prompt": prompt,
            "size": selectedResolution.string,
            "n": numberOfImages,
        ]
        return try? JSONSerialization.data(withJSONObject: dict, options: [])
    }
}
