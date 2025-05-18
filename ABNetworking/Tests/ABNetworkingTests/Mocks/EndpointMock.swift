//
//  EndpointMock.swift
//  ABNetworking
//
//  Created by Abid Bhatti on 18/01/25.
//

import Foundation
@testable import ABNetworking

struct EndpointMock: Endpoint {
    var scheme: String
    var host: String
    var path: String
    var httpMethod: HTTPMethod
    var headers: [String: String]?
    var queryItems: [String: Any]?
    var body: Data?
    
    init(
        scheme: String = "https",
        host: String = "example.com",
        path: String = "/test",
        httpMethod: HTTPMethod = .get,
        headers: [String: String]? = nil,
        queryItems: [String: Any]? = nil,
        body: Data? = nil
    ) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.httpMethod = httpMethod
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
    }
}
