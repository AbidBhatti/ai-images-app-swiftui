//
//  OpenAIService.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 19/01/25.
//

import Foundation
import ABNetworking

final class OpenAIService {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    convenience init() {
        self.init(httpClient: HTTPClient())
    }
    
    func generateImage(from endpoint: Endpoint) async throws -> ImageResponse {
        let imageResponse: ImageResponse = try await httpClient.data(from: endpoint)
        return imageResponse
    }
}
