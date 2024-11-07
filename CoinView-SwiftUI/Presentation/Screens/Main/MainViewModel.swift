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
    public var isMoreDataAvailable: Bool {
        coins.count > list.count || !isLoaded
    }
    
    @Published var reloadingState: PaginationState = .reload
    
    // начальная загрузка
    private var isLoaded = false
    private var taskLoading: Task<(), Never>?
    
    // MARK: - Loading
    public func loadData() {
        guard repository != nil, taskLoading == nil else { return }
        print("MainViewModel: \(#function)")
        
        taskLoading = Task { [weak self] in
            await self?.setReloadingState(.loading)
            
            let result = await self?.repository?.fetchCoins()
            
            switch result {
            case .success(let coins):
                print("MainViewModel: coins = \(coins.count)")
                self?.coins = coins
                self?.isLoaded = true
                
                do {
                    try await self?.preloadList(12)
                    await self?.setReloadingState(.reload)
                } catch {
                    await self?.showError(error)
                }
            case .failure(let error):
                await self?.showError(error)
            case .none:
                break
            }
            self?.taskLoading = nil
        }
    }
    
    // MARK: - Checking the need for additional loading
    public func loadMoreItems() {
        // если не было загружено, то сначало загрузим
        if !isLoaded {
            loadData()
            return
        }
        guard isMoreDataAvailable, taskLoading == nil else { return }
        
        print("MainViewModel: \(#function)")
        taskLoading = Task { [weak self] in
            await self?.setReloadingState(.loading)
            
            do {
                try await self?.preloadList()
                await self?.setReloadingState(.reload)
            } catch {
                await self?.showError(error)
            }
            self?.taskLoading = nil
        }
    }
    
    private func preloadList(_ count: Int = 3) async throws {
        var newList: [Coin] = []
        var index = self.list.endIndex
        print("MainViewModel: \(#function) get logo: index=\(index), count=\(count)")
        do {
            for _ in 0..<count {
                guard 0..<self.coins.endIndex ~= index else { break }
                
                let coin = self.coins[index]
                
                let logo = try await fetchCoinDetailAndLogo(coin.id)
                newList.append(logo == nil ? coin : coin.copy(logo: logo))
                
                index += 1
            }
            await addList(newList)
        } catch {
            // сохраним, если что-то есть
            await addList(newList)
            
            throw error
        }
    }
    
    @MainActor
    private func setReloadingState(_ state: PaginationState) {
        if case .reload = state, !isMoreDataAvailable {
            self.reloadingState = .none
        } else {
            self.reloadingState = state
        }
    }
    
    // MARK: - Loading coin logo picture and CoinDetail
    private func fetchCoinDetailAndLogo(_ id: String) async throws -> Data? {
        print("MainViewModel: \(#function) get logo: \(id)")
        let result = await self.repository?.fetchCoinDetail(id: id)
        switch result {
        case .success(let coinDetail):
            // добавим в общий список
            await self.addCoinDetail(coinDetail)
            // вернем logo
            return coinDetail.logo
        case .failure(let error):
            throw error
        case .none:
            break
        }
        return nil
    }
    
    public func getCoinDetail(by id: String) -> CoinDetail? {
        guard !id.isEmpty else { return nil }
        
        return coinsDetail.first(where: { $0.id == id })
    }
    
    // MARK: - Show error
    @MainActor
    private func showError(_ error: Error) {
        print("MainViewModel: coins error: \(error.localizedDescription)")
        // если это NetworkError то покажем наше сообщение
        if let error = error as? NetworkError {
            setReloadingState(.error(message: error.localizedDescription))
        } else {
            setReloadingState(.error(message: error.localizedDescription))
        }
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
