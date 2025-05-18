//
//  File.swift
//  ABNetworking
//
//  Created by Abid Bhatti on 18/01/25.
//

import Foundation

public extension URLSession {
    static var mock: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: configuration)
    }
}
