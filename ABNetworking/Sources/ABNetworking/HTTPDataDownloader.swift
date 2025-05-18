//
//  HTTPDataDownloader.swift
//  ABNetworking
//
//  Created by Abid Bhatti on 16/01/25.
//

import Foundation

public protocol HTTPDataDownloading {
    func downloadData(for url: URLRequest) async throws -> Data
}

public final class HTTPDataDownloader: HTTPDataDownloading {
    
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func downloadData(for request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw APIClientError.invalidResponse
        }
        switch response.statusCode {
        case 200...299:
            return data
        default:
            throw APIClientError.statusCode(response.statusCode)
        }
    }
}
