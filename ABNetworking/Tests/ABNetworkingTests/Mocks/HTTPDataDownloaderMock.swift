//
//  HTTPDataDownloaderMock.swift
//  ABNetworking
//
//  Created by Abid Bhatti on 18/01/25.
//

import Foundation
@testable import ABNetworking

final class HTTPDataDownloaderMock: HTTPDataDownloading {
    var dataToReturn: Data?
    var errorToThrow: Error?
    
    func downloadData(for url: URLRequest) async throws -> Data {
        if let error = errorToThrow {
            throw error
        }
        return dataToReturn ?? Data()
    }
}
