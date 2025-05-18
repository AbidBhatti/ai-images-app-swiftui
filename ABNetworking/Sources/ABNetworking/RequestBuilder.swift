//
//  RequestBuilder.swift
//  ABNetworking
//
//  Created by Abid Bhatti on 18/01/25.
//

import Foundation

public protocol RequestBuilding {
    func buildRequest(for endpoint: Endpoint) throws -> URLRequest
}

public final class RequestBuilder: RequestBuilding {
    
    public init() {}
    
    public func buildRequest(for endpoint: any Endpoint) throws -> URLRequest {
        let url = try buildURL(from: endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body
        return request
    }
    
    private func buildURL(from endpoint: Endpoint) throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        if let queryItems = endpoint.queryItems {
            urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
        }
        
        guard let url = urlComponents.url else {
            throw APIClientError.invalidURL
        }
        
        return url
    }
}
