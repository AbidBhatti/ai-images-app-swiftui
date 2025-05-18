//
//  File.swift
//  ABNetworking
//
//  Created by Abid Bhatti on 18/01/25.
//

import Foundation

extension JSONDecoder {
    func decode<T: Decodable>(from data: Data) throws -> T {
        do {
            return try decode(T.self, from: data)
        } catch {
            throw APIClientError.decodingError(error)
        }
    }
}
