//
//  Reachability.swift
//  ABNetworking
//
//  Created by Abid Bhatti on 16/01/25.
//

import Foundation
import Network

public protocol ReachabilityProviding {
    func isConnected() async -> Bool
}

public final class Reachability: ReachabilityProviding {
    public func isConnected() async -> Bool {
        
        typealias Continuation = CheckedContinuation<Bool, Never>
        
        return await withCheckedContinuation({ (continuation: Continuation) in
            let monitor = NWPathMonitor()
            
            monitor.pathUpdateHandler = { path in
                monitor.cancel()
                switch path.status {
                case .satisfied:
                    continuation.resume(returning: true)
                case .unsatisfied, .requiresConnection:
                    continuation.resume(returning: false)
                @unknown default:
                    continuation.resume(returning: false)
                }
            }
            monitor.start(queue: DispatchQueue(label: "NetworkReachabilityMonitor"))
        })
    }
}
