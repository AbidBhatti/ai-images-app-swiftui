//
//  HTTPClient.swift
//  ABNetworking
//
//  Created by Abid Bhatti on 18/01/25.
//

import Foundation

public protocol HTTPClientProviding {
    func data(from endpoint: Endpoint) async throws -> Data
    func data<T: Decodable>(from endpoint: Endpoint) async throws -> T
}

public final class HTTPClient: HTTPClientProviding {
    private let downloader: HTTPDataDownloading
    private let requestBuilder: RequestBuilding
    private let reachability: ReachabilityProviding
    
    private lazy var decoder: JSONDecoder = {
        let aDecoder = JSONDecoder()
        return aDecoder
    }()
    
    public init(downloader: HTTPDataDownloading, requestBuilder: RequestBuilding, reachability: ReachabilityProviding) {
        self.downloader = downloader
        self.requestBuilder = requestBuilder
        self.reachability = reachability
    }
    
    public convenience init() {
        self.init(downloader: HTTPDataDownloader(session: URLSession.shared),
                  requestBuilder: RequestBuilder(),
                  reachability: Reachability())
    }
    
    public func data(from endpoint: any Endpoint) async throws -> Data {
        guard await reachability.isConnected() else {
            throw APIClientError.networkError
        }
        let request = try requestBuilder.buildRequest(for: endpoint)
        return try await downloader.downloadData(for: request)
    }
    
    public func data<T>(from endpoint: any Endpoint) async throws -> T where T : Decodable {
        guard await reachability.isConnected() else {
            throw APIClientError.networkError
        }
        let request = try requestBuilder.buildRequest(for: endpoint)
        let data = try await downloader.downloadData(for: request)
        return try decoder.decode(from: data)
    }
}
