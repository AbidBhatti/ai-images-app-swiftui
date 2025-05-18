//
//  APIClientError.swift
//  ABNetworking
//
//  Created by Abid Bhatti on 16/01/25.
//

import Foundation

public enum APIClientError: Error {
    case invalidResponse
    case invalidData
    case invalidURL
    case requestFailed(Error)
    case decodingError(Error)
    case statusCode(Int)
    case networkError
    case unknown
}

extension APIClientError {
    public var message: String {
        switch self {
        case .invalidResponse:
            return "We received an invalid response from the server."
        case .invalidData:
            return "The data received from the server is not in the expected format."
        case .invalidURL:
            return "The URL used for the request is invalid."
        case .requestFailed(let error):
            return "The request failed due to an error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "We encountered an error while processing the data: \(error.localizedDescription)"
        case .statusCode(let statusCode):
            return "The server returned an unexpected status code: \(statusCode)."
        case .networkError:
            return "There seems to be a network issue. Please check your internet connection."
        case .unknown:
            return "An unknown error occurred. Please try again later."
        }
    }
}

extension APIClientError: Equatable {
    public static func == (lhs: APIClientError, rhs: APIClientError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidResponse, .invalidResponse),
            (.invalidData, .invalidData),
            (.invalidURL, .invalidURL),
            (.networkError, .networkError),
            (.unknown, .unknown):
            return true
        case (.requestFailed(let lhsError), .requestFailed(let rhsError)):
            return (lhsError as NSError).domain == (rhsError as NSError).domain &&
            (lhsError as NSError).code == (rhsError as NSError).code
        case (.decodingError(let lhsError), .decodingError(let rhsError)):
            return (lhsError as NSError).domain == (rhsError as NSError).domain &&
            (lhsError as NSError).code == (rhsError as NSError).code
        case (.statusCode(let lhsCode), .statusCode(let rhsCode)):
            return lhsCode == rhsCode
        default:
            return false
        }
    }
}
