//
//  HTTPClientTests.swift
//  ABNetworking
//
//  Created by Abid Bhatti on 18/01/25.
//

import Foundation
import Testing
@testable import ABNetworking

@Suite("Tests for HTTP Client")
struct HTTPClientTests {

    var httpClient: HTTPClientProviding
    var mockDownloader: HTTPDataDownloaderMock
    var mockRequestBuilder: RequestBuilderMock
    var mockReachability: ReachabilityMock

    init() {
        mockDownloader = HTTPDataDownloaderMock()
        mockRequestBuilder = RequestBuilderMock()
        mockReachability = ReachabilityMock()
        httpClient = HTTPClient(
            downloader: mockDownloader,
            requestBuilder: mockRequestBuilder,
            reachability: mockReachability
        )
    }

    @Test("Successful data fetching")
    func dataFetchSuccess() async throws {
        let expectedData = Data("Hello, World!".utf8)
        mockDownloader.dataToReturn = expectedData
        let endpoint = EndpointMock()

        let result: Data = try await httpClient.data(from: endpoint)
        #expect(result == expectedData)
    }

    @Test("Reachability failure")
    func networkDisconnected() async throws {
        mockReachability.isConnected = false
        let endpoint = EndpointMock()

        do {
            _ = try await httpClient.data(from: endpoint)
        } catch {
            #expect((error as? APIClientError) == .networkError)
        }
    }

    @Test("Request builder error")
    func requestBuildingError() async throws {
        mockRequestBuilder.errorToThrow = APIClientError.invalidURL
        let endpoint = EndpointMock()

        do {
            _ = try await httpClient.data(from: endpoint)
        } catch {
            #expect((error as? APIClientError) == .invalidURL)
        }
    }

    @Test("Successful JSON decoding")
    func jsonDecodingSuccess() async throws {
        struct TestModel: Decodable, Equatable {
            let message: String
        }

        let jsonData = Data(#"{"message": "Hello, JSON"}"#.utf8)
        mockDownloader.dataToReturn = jsonData
        let endpoint = EndpointMock()

        let result: TestModel = try await httpClient.data(from: endpoint)
        #expect(result == TestModel(message: "Hello, JSON"))
    }

    @Test("JSON decoding error")
    func jsonDecodingFailure() async throws {
        struct TestModel: Decodable {
            let message: String
        }

        let invalidJsonData = Data("invalid json".utf8)
        mockDownloader.dataToReturn = invalidJsonData
        let endpoint = EndpointMock()

        do {
            _ = try await httpClient.data(from: endpoint) as TestModel
        } catch let error as APIClientError {
            var isDecodingError = false
            switch error {
            case .decodingError(_):
                isDecodingError = true
            default:
                break
            }
            #expect(isDecodingError)
        }
    }
}
