//
//  HTTPDataDownloaderTests.swift
//  ABNetworking
//
//  Created by Abid Bhatti on 18/01/25.
//

import Foundation
import Testing
@testable import ABNetworking

@Suite("Tests for Data Downloading using HTTP")
struct HTTPDataDownloaderTests {
    
    var dataDownloader: HTTPDataDownloading
    
    init() {
        let session = URLSession.mock
        dataDownloader = HTTPDataDownloader(session: session)
    }
    
    @Test("Data downloaded successfully")
    func downloadDataSuccess() async throws {
        let data = Data("Hello, World!".utf8)
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        let request = URLRequest(url: URL(string: "https://www.example.com")!)
        let result = try await dataDownloader.downloadData(for: request)
        #expect(result == data)
    }
    
    @Test("Status code error")
    func invalidStatusCode() async throws {
        let data = Data()
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        let request = URLRequest(url: URL(string: "https://www.example.com")!)
        do {
            _ = try await dataDownloader.downloadData(for: request)
        } catch {
            #expect((error as? APIClientError) == .statusCode(404))
        }
    }
    
    @Test("Not a valid response")
    func invalidResponse() async throws {
        let data = Data()
        URLProtocolMock.requestHandler = { request in
            return (HTTPURLResponse(), data)
        }
        let request = URLRequest(url: URL(string: "https://www.example.com")!)
        do {
            _ = try await dataDownloader.downloadData(for: request)
        } catch {
            #expect((error as? APIClientError) == .invalidResponse)
        }
    }
}
