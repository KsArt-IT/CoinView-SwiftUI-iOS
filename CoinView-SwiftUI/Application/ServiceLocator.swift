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
        let coinService: CoinNetworkService = CoinNetworkServiceImpl()
        let coinRepository: CoinRepository = CoinRepositoryImpl(service: coinService)
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
