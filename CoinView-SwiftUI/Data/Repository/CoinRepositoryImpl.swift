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
    
    // вернем количество, но если в базе данных не или устарели, то первоначальная загрузка
    func fetchData() async -> Result<Int, any Error> {
        print("CoinRepositoryImpl: \(#function)")
        
        // из кеша базы и только количество
        if isInCache(), let count = await dataService.fetchCount(of: CoinModel.self) {
            debugPrint("CoinRepositoryImpl: \(#function) dataService")
            return .success(count)
        }
        // из сети возьмем весь список
        let result: Result<[CoinDto], Error> = await networkService.fetchData(endpoint: .coins)
        
        switch result {
        case .success(let coinsDto):
            
            // сохраняем весь список, но
            // TODO: необходимо вывести пользователю, что идет полное сохранение в базу
            await self.saveData(coinsDto)
            // отдаем только количество
            return .success(coinsDto.count)
        case .failure(let error):
            
            // если ошибка, возьмем то, что есть в кеше
            if let count = await dataService.fetchCount(of: CoinModel.self) {
                debugPrint("CoinRepositoryImpl: \(#function) dataService")
                return .success(count)
            } else {
                return .failure(error)
            }
        }
    }
    
    // MARK: - Download list of coins from network or data
    func fetchCoins(index: Int, count: Int) async -> Result<[Coin], any Error> {
        // загрузить из базы
        let coins = dataService.fetchData(index: index, count: count)
        guard let coins else { return .failure(NetworkError.cancelled)}
        
        var coinsWithLogo: [Coin] = []
        for coin in coins {
            print("CoinRepositoryImpl: \(#function) logo: \(coin.logo?.data)")
            if let logo = coin.logo, logo.data != nil {
                coinsWithLogo.append(coin.mapToDomain())
            } else if let data = await fetchLogo(by: coin.id) {
                await updateLogo(coin.id, logo: data)
                coinsWithLogo.append(coin.mapToDomain(logo: data))
            }
        }
        return .success(coinsWithLogo)
    }
    
    private func isInCache() -> Bool {
        // получим информацию
        guard let info = self.dataService.fetchInfo() else { return false }
        
        return info.count > 0 && Date().timeIntervalSince(info.dateUpdate) < 86400 * 3 // дней
    }
    
    // MARK: - Download coin detail from data or network
    func fetchCoinDetail(by id: String) async -> Result<CoinDetail, any Error> {
        // с начала из базы
        if let coin = dataService.fetchData(by: id) {
            print("CoinRepositoryImpl: \(#function) dataService")
            return .success(coin.mapToDomain())
        }
        print("CoinRepositoryImpl: \(#function) networkService")
        let result: Result<CoinDetailDto, any Error> = await networkService.fetchData(endpoint: .coin(id: id))
        
        switch result {
        case .success(let dto):
            let logo = await fetchLogo(for: dto.logo)
            let coin = dto.mapToModel(logo)
            // сохраним в базу
            dataService.saveData(coin)
            return .success(coin.mapToDomain())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    // MARK: - Download coin logo from network
    private func fetchLogo(for url: String?) async -> Data? {
        guard let url else { return nil }
        
        return await networkService.fetchData(url: url)
    }
    
    private func fetchLogo(by id: String) async -> Data? {
        debugPrint("CoinRepositoryImpl: \(#function) id: \(id)")
        guard !id.isEmpty else { return nil }
        
        // возьмем из базы
        if let logo = await dataService.fetchLogo(by: id) {
            return logo.data
        }
        // из CoinDetail
        if let coinDetail = dataService.fetchData(by: id), let logo = coinDetail.logo {
            return logo.data
        }
        // из сети
        if case .success(let coin) = await fetchCoinDetail(by: id), let logo = coin.logo {
            return logo
        }
        return nil
    }
    
    // MARK: - Save coin to data
    private func saveData(_ coinsDto: [CoinDto]) async {
        guard !coinsDto.isEmpty else { return }
        debugPrint("CoinRepositoryImpl: \(#function) saveData: coinsDto")
        // сохраним первый коин с logo и детальной информацией
        if let coin = coinsDto.first {
            _ = await fetchCoinDetail(by: coin.id)
        }
        // добавляем номер по порядку, для сортировки и отображения, как был загружен список
        let coinsModel = coinsDto.enumerated().map { (index, coin) in
            coin.mapToModel(index)
        }
        self.dataService.saveData(coinsModel)
    }
    
    private func saveData(_ coin: CoinModel) async {
        debugPrint("CoinRepositoryImpl: \(#function) saveData: coin logo=\(String(describing: coin.logo))")
        dataService.saveData(coin)
    }
    
    private func updateLogo(_ id: String, logo: Data) async {
        await dataService.updateLogo(by: id, logo: logo)
    }
}
