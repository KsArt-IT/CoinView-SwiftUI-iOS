//
//  CoinRepositoryImpl.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 05.11.2024.
//

import Foundation

final class CoinRepositoryImpl: CoinRepository {
    private let service: CoinNetworkService
    
    init(service: CoinNetworkService) {
        self.service = service
    }
    
    func fetchCoins() async -> Result<[Coin], any Error> {
        print("CoinRepositoryImpl: \(#function)")
        let result: Result<[CoinDto], Error> = await service.fetchData(endpoint: .coins)
        
        return switch result {
        case .success(let coinsDto):
                .success(coinsDto.map { $0.mapToDomain() })
        case .failure(let error):
                .failure(error)
        }
    }
    
    func fetchCoinDetail(id: String) async -> Result<CoinDetail, any Error> {
        let result: Result<CoinDetailDto, any Error> = await service.fetchData(endpoint: .coin(id: id))
        
        switch result {
        case .success(let dto):
            let logo = await fetchLogo(dto.logo)
            return .success(dto.mapToDomain(logo))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func fetchLogo(_ url: String?) async -> Data? {
        guard let url else { return nil }
        
        return await service.fetchData(url: url)
    }
}
