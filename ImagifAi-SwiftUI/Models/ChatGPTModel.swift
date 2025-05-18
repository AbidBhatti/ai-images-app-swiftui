//
//  ChatGPTModel.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 18/12/24.
//

import Foundation

enum ChatGPTModel: String, CaseIterable {
    case dalle2 = "dall-e-2"
    case dalle3 = "dall-e-3"
    
    var name: String {
        switch self {
        case .dalle2:
            "Dall-E-2"
        case .dalle3:
            "Dall-E-3"
        }
    }
}

extension ChatGPTModel {
    var resolutions: [ImageResolution] {
        switch self {
        case .dalle2:
            [.small256x256, .medium512x512, .large1024x1024]
        case .dalle3:
            [.large1024x1024, .portrait1024x1792, .landscape1792x1024]
        }
    }
}
