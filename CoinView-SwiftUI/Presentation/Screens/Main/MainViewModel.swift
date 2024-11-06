//
//  MainViewModel.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import Foundation

final class MainViewModel: ObservableObject {
    private let repository: CoinRepository? = ServiceLocator.shared.resolve()
    
    // список, который отображается
    @Published var list: [Coin] = []
    // весь список для дозагрузки и пагинации
    private var coins: [Coin] = []
    // детальная информация о coin, загружается для logo и для отображения
    private var coinsDetail: [CoinDetail] = []
    
    @Published var reloadingState: PaginationState = .none
    
    init() {
        loadData()
    }
    
    // MARK: - Loading
    public func loadData() {
        print("MainViewModel: \(#function)")
        guard repository != nil else { return }
        
        Task { [weak self] in
            await self?.setReloadingState(.loading)
            
            let result = await self?.repository?.fetchCoins()
            
            switch result {
            case .success(let coins):
                print("MainViewModel: coins = \(coins.count)")
                self?.coins = coins
                await self?.preloadList(10)
                if let list = self?.list, !list.isEmpty {
                    await self?.setReloadingState(.none)
                } else {
                    await self?.setReloadingState(.error(message: "Reload"))
                }
            case .failure(let error):
                print("MainViewModel: coins error: \(error.localizedDescription)")
                await self?.setReloadingState(.error(message: error.localizedDescription))
            case .none:
                break
            }
        }
    }
    
    // MARK: - Checking the need for additional loading
    public func isLastItemAndMoreDataAvailable(_ coin: Coin) -> Bool {
        coins.count > list.count && list.last == coin
    }
    
    public func loadMoreItems() {
        Task { [weak self] in
            await self?.setReloadingState(.loading)
            await self?.preloadList()
            await self?.setReloadingState(.none)
        }
    }
    
    @MainActor
    private func setReloadingState(_ state: PaginationState) {
        self.reloadingState = state
    }
    
    private func preloadList(_ count: Int = 3) async {
        var newList: [Coin] = []
        var index = self.list.endIndex
        print("MainViewModel: \(#function) get logo: index=\(index), count=\(count)")
        for _ in 0...count {
            guard 0..<self.coins.endIndex ~= index else { break }
            let coin = self.coins[index]
            let logo = await fetchCoinDetailAndLogo(coin.id)
            newList.append(logo == nil ? coin : coin.copy(logo: logo))
            index += 1
        }
        await addList(newList)
    }
    
    // MARK: - Loading coin logo picture and CoinDetail
    private func fetchCoinDetailAndLogo(_ id: String) async -> Data? {
        print("MainViewModel: \(#function) get logo: \(id)")
        let result = await self.repository?.fetchCoinDetail(id: id)
        switch result {
        case .success(let coinDetail):
            // добавим в общий список
            await self.addCoinDetail(coinDetail)
            // вернем logo
            return coinDetail.logo
        case .failure(let error):
            print("MainViewModel: error: \(error.localizedDescription)")
        case .none:
            break
        }
        return nil
    }
    
    public func getCoinDetail(by id: String) -> CoinDetail? {
        guard !id.isEmpty else { return nil }
        
        return coinsDetail.first(where: { $0.id == id })
    }
    
    // MARK: - List change
    private func addList(_ coins: [Coin]) async {
        guard !coins.isEmpty else { return }
        let newList = self.list + coins
        await setList(newList)
    }
    
    @MainActor
    private func setList(_ newList: [Coin]) {
        self.list = newList
    }
    
    @MainActor
    private func addCoinDetail(_ coin: CoinDetail) {
        self.coinsDetail.append(coin)
    }
    
}
