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
    // начальная загрузка
    private var isLoaded = false
    private var taskLoading: Task<(), Never>?
    
    // для поиска
    @Published var search = "" {
        didSet {
            updateSearch()
        }
    }
    @Published var listSearch: [Coin] = []
    private var taskSearch: Task<(), Never>?
    
    // весь список для дозагрузки и пагинации
    private var count: Int = 0
    @Published var countLoaded: Int = 0
    public var isMoreDataAvailable: Bool {
        count > list.count || !isLoaded
    }
    
    public var progressLoaded: Double {
        if search.isEmpty {
            list.isEmpty ? 0.0 : Double(list.count) / Double(count)
        } else {
            listSearch.isEmpty ? 0.0 : Double(listSearch.count) / Double(count)
        }
    }
    
    @Published var reloadingState: PaginationState = .reload
    
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
        guard isMoreDataAvailable, taskLoading == nil else { return }
        
        print("MainViewModel: \(#function)")
        taskLoading = Task { [weak self] in
            await self?.setReloadingState(.loading)
            
            await self?.preloadList()
            await self?.setReloadingState(.reload)
            self?.taskLoading = nil
        }
    }
    
    private func preloadList(_ count: Int = 10) async {
        let index = self.list.endIndex
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
    
    // MARK: - Search
    private func updateSearch() {
        taskSearch?.cancel()
        
        self.taskSearch = Task(priority: .utility) { [weak self] in
            if let coins = await self?.preloadListSearch(), !Task.isCancelled {
                await self?.setListSearch(coins)
            }
        }
    }
    
    private func preloadListSearch() async -> [Coin]? {
        guard !search.isEmpty else { return nil }
        
        return if case .success(let coins) = await repository?.fetchCoins(filter: search) {
            coins
        } else {
            nil
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
        setLoaded()
    }
    
    @MainActor
    private func setListSearch(_ newList: [Coin]) {
        print("MainViewModel: \(#function) filter count=\(newList.count)")
        self.listSearch = newList
        setLoaded()
    }
    
    private func setLoaded() {
        self.countLoaded = if search.isEmpty {
            self.list.count
        } else {
            self.listSearch.count
        }
    }
    
    // MARK: - Cancel
    deinit {
        taskSearch?.cancel()
        taskLoading?.cancel()
    }
}
