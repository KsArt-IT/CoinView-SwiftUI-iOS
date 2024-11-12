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
    private var count: Int = 0
    public var isMoreDataAvailable: Bool {
        count > list.count || !isLoaded
    }
    
    @Published var reloadingState: PaginationState = .reload
    
    // начальная загрузка
    private var isLoaded = false
    private var taskLoading: Task<(), Never>?
    
    init() {
        preloadData()
    }
    
    // MARK: - Loading
    public func preloadData() {
        guard repository != nil, taskLoading == nil else { return }
        print("MainViewModel: \(#function)")
        
        taskLoading = Task { [weak self] in
            await self?.setReloadingState(.loading)
            
            let result = await self?.repository?.fetchData()
            
            switch result {
            case .success(let count):
                print("MainViewModel: count = \(count)")
                self?.count = count
                self?.isLoaded = true
                
                await self?.setReloadingState(.reload)
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
//            fetchData()
            return
        }
        guard isMoreDataAvailable, taskLoading == nil else { return }
        
        print("MainViewModel: \(#function)")
        taskLoading = Task { [weak self] in
            await self?.setReloadingState(.loading)
            
            await self?.preloadList()
            await self?.setReloadingState(.reload)
            self?.taskLoading = nil
        }
    }
    
    private func preloadList(_ count: Int = 3) async {
        var index = self.list.endIndex
        print("MainViewModel: \(#function) get logo: index=\(index), count=\(count)")
        let result = await repository?.fetchCoins(index: index, count: count)
        switch result {
        case .success(let coins):
            await addList(coins)
        case .failure(let error):
            await showError(error)
        case .none:
            break
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
    
}
