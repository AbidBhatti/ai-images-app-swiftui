//
//  File.swift
//  ABNetworking
//
//  Created by Abid Bhatti on 18/01/25.
//

import Foundation

public protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [String: Any]? { get }
    var body: Data? { get }
}
