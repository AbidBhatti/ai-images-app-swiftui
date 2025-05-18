//
//  ReachabilityMock.swift
//  ABNetworking
//
//  Created by Abid Bhatti on 18/01/25.
//

import Foundation
@testable import ABNetworking

final class ReachabilityMock: ReachabilityProviding {
    var isConnected: Bool = true
    
    func isConnected() async -> Bool {
        return isConnected
    }
}
