//
//  ServiceLocator.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 05.11.2024.
//

import Foundation

final class ServiceLocator {
    static let shared = ServiceLocator()
    
    private var services: [String: Any] = [:]
    
    private init() {
        // Network service
        let coinService: CoinNetworkService = CoinNetworkServiceImpl()
        // Data service
        let coinDataService: CoinDataService = CoinDataServiceImpl()
        // Repository
        let coinRepository: CoinRepository = CoinRepositoryImpl(network: coinService, data: coinDataService)
        register(service: coinRepository)
    }
    
    func register<T>(service: T) {
        let key = "\(T.self)"
        services[key] = service
    }
    
    func resolve<T>() -> T? {
        let key = "\(T.self)"
        return services[key] as? T
    }
    
}
