//
//  NetworkMonitor.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 14/11/2023.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    @Published private(set) var isConnected = true
    @Published private(set) var isCellular = true
    
    private let nwMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue.global()
    
    public func start() {
        nwMonitor.start(queue: workerQueue)
        nwMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.isCellular = path.usesInterfaceType(.cellular)
            }
        }
    }
    
    public func stop() {
        nwMonitor.cancel()
    }
}
