//
//  CoinRepositoryImpl.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 05.11.2024.
//

import Foundation

final class CoinRepositoryImpl: CoinRepository {
    private let networkService: CoinNetworkService
    private let dataService: CoinDataService
    
    init(network: CoinNetworkService, data: CoinDataService) {
        self.networkService = network
        self.dataService = data
    }
    
    // MARK: - Download list of coins from network or data
    func fetchCoins() async -> Result<[Coin], any Error> {
        print("CoinRepositoryImpl: \(#function)")
        let result: Result<[CoinDto], Error> = await networkService.fetchData(endpoint: .coins)
        
        switch result {
        case .success(let coinsDto):
            
            self.saveData(coinsDto)

            return .success(coinsDto.map { $0.mapToDomain() })
        case .failure(let error):

            if let coinModel = dataService.fetchData() {
                debugPrint("CoinRepositoryImpl: \(#function) dataService")
                return .success(coinModel.map { $0.mapToDomain() })
            } else {
                return .failure(error)
            }
        }
    }
    
    // MARK: - Download coin detail from data or network
    func fetchCoinDetail(id: String) async -> Result<CoinDetail, any Error> {
        if let coin = dataService.fetchData(by: id) {
            print("CoinRepositoryImpl: \(#function) dataService")
            return .success(coin.mapToDomain())
        }
        print("CoinRepositoryImpl: \(#function) networkService")
        let result: Result<CoinDetailDto, any Error> = await networkService.fetchData(endpoint: .coin(id: id))
        
        switch result {
        case .success(let dto):
            let logo = await fetchLogo(dto.logo)
            let coin = dto.mapToModel(logo)
            dataService.saveData(coin)
            return .success(coin.mapToDomain())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    // MARK: - Download coin logo from network
    private func fetchLogo(_ url: String?) async -> Data? {
        guard let url else { return nil }
        
        return await networkService.fetchData(url: url)
    }
    
    // MARK: - Save coin to data
    private func saveData(_ coinsDto: [CoinDto]) {
        guard !coinsDto.isEmpty else { return }
        debugPrint("CoinRepositoryImpl: \(#function) saveData: coinsDto")

        Task { [weak self] in
            // получим информацию
            let info = self?.dataService.fetchInfo()
            // если количество разное
            if info == nil || info?.count != coinsDto.count {
                let coinsModel = coinsDto.map { $0.mapToModel() }
                self?.dataService.saveData(coinsModel)
            }
        }
    }
    
    func saveData(_ coin: Coin) async {
        debugPrint("CoinRepositoryImpl: \(#function) saveData: coin")
        dataService.saveData(coin.mapToModel())
    }
}
