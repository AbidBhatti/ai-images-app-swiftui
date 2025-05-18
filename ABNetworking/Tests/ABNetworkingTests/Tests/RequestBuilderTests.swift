//
//  RequestBuilderTests.swift
//  ABNetworking
//
//  Created by Abid Bhatti on 18/01/25.
//

import Foundation
import Testing
@testable import ABNetworking

@Suite("Tests for Request Builder")
struct RequestBuilderTests {
    var requestBuilder: RequestBuilding
    
    init() {
        requestBuilder = RequestBuilder()
    }
    
    @Test("Successfully builds a URLRequest")
    func buildRequestSuccess() throws {
        let endpoint = EndpointMock(
            scheme: "https",  // Ensure this is valid
            host: "api.example.com",
            path: "/test",
            httpMethod: .get,
            headers: ["Content-Type": "application/json"],
            queryItems: ["query": "test"],
            body: nil
        )
        
        let request = try requestBuilder.buildRequest(for: endpoint)
        
        #expect(request.url?.absoluteString == "https://api.example.com/test?query=test")
        #expect(request.httpMethod == "GET")
        #expect(request.allHTTPHeaderFields?["Content-Type"] == "application/json")
        #expect(request.httpBody == nil)
    }
    
    @Test("Throws an error for an invalid URL")
    func invalidURL() {
        let endpoint = EndpointMock(
            scheme: "https",
            host: "api.examplecom",
            path: "/test",
            httpMethod: .get,
            headers: nil,
            queryItems: nil,
            body: nil
        )
        
        do {
            _ = try requestBuilder.buildRequest(for: endpoint)
        } catch {
            #expect(error is APIClientError)
            #expect((error as? APIClientError) == .invalidURL)
        }
    }
    
    @Test("Correctly builds a URL with query items")
    func buildRequestWithQueryItems() throws {
        let endpoint = EndpointMock(
            scheme: "https",  // Ensure this is valid
            host: "api.example.com",
            path: "/test",
            httpMethod: .get,
            headers: nil,
            queryItems: ["key1": "value1", "key2": "value2"],
            body: nil
        )
        
        let request = try requestBuilder.buildRequest(for: endpoint)
        
        // Get the query items from the request URL
        guard let url = request.url else {
            throw APIClientError.invalidURL
        }
        
        let queryItems = URLComponents(string: url.absoluteString)?.queryItems
        
        // Sort query items by name and then check that the values match
        let sortedQueryItems = queryItems?.sorted { $0.name < $1.name }
        
        // Check if the query items contain the expected values
        #expect(sortedQueryItems?.count == 2)
        #expect(sortedQueryItems?.first(where: { $0.name == "key1" })?.value == "value1")
        #expect(sortedQueryItems?.first(where: { $0.name == "key2" })?.value == "value2")
    }
}
