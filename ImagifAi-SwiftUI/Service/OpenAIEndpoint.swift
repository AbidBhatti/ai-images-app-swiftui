//
//  OpenAIEndpoint.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 19/01/25.
//

import Foundation
import ABNetworking

enum OpenAIEndpoint: Endpoint {
    
    case imagesGeneration(ImageGenerationUserInput)
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "api.openai.com"
    }
    
    var path: String {
        return "/v1/images/generations"
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(Config.OPEN_AI_API_KEY)"
        ]
    }
    
    var queryItems: [String : Any]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .imagesGeneration(let userInput):
            return userInput.encodedData()
        }
    }
}
