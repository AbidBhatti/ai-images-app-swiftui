//
//  URLProtocolMock.swift
//  ABNetworking
//
//  Created by Abid Bhatti on 18/01/25.
//

import Foundation

final class URLProtocolMock: URLProtocol {
    
    nonisolated(unsafe)
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let client else {
            fatalError("No client found")
        }
        
        guard let requestHandler = URLProtocolMock.requestHandler else {
            fatalError("Handler should be provided")
        }
        
        do {
            let (response, data) = try requestHandler(request)
            client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client.urlProtocol(self, didLoad: data)
            client.urlProtocolDidFinishLoading(self)
        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // empty implementation, not required
    }

}
