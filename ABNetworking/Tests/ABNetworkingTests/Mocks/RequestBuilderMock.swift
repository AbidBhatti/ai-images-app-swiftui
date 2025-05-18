//
//  RequestBuilderMock.swift
//  ABNetworking
//
//  Created by Abid Bhatti on 18/01/25.
//

import Foundation
@testable import ABNetworking

final class RequestBuilderMock: RequestBuilding {
    var requestToReturn: URLRequest?
    var errorToThrow: Error?
    
    func buildRequest(for endpoint: Endpoint) throws -> URLRequest {
        if let error = errorToThrow {
            throw error
        }
        return requestToReturn ?? URLRequest(url: URL(string: "https://example.com")!)
    }
}
