//
//  CoinDataServiceImpl.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 08.11.2024.
//

import Foundation
import SwiftData

final class CoinDataServiceImpl: @preconcurrency CoinDataService {
    
    var container: ModelContainer = {
        do {
            let container = try ModelContainer(
                for: InfoModel.self, CoinLogoModel.self, CoinModel.self, CoinDetailModel.self,
                configurations: ModelConfiguration()
            )
            return container
        } catch {
            fatalError("Failed to create a container SwiftData")
        }
    }()
    
    lazy var context: ModelContext = {
        let context = ModelContext(container)
        context.autosaveEnabled = false
        return context
    }()
    
    // MARK: - Info
    func fetchInfo() -> InfoModel? {
        let info = try? context.fetch(FetchDescriptor<InfoModel>())
        return info?.last
    }
    
    private func saveInfo(_ count: Int) {
        print("CoinDataServiceImpl: \(#function)")
        context.insert(InfoModel(count: count))
        save()
    }
    
    // MARK: - Coin
    func fetchCount<T: PersistentModel>(of entity: T.Type) async -> Int? {
        let request = FetchDescriptor<T>()
        
        do {
            let count = try context.fetchCount(request)
            return count
        } catch {
            return nil
        }
    }
    
    func fetchData() -> [CoinModel]? {
        let coins = try? context.fetch(FetchDescriptor<CoinModel>())
        print("CoinDataServiceImpl: fetchData: \(coins?.count ?? 0)")
        return coins
    }
    
    func fetchData(index: Int, count: Int) -> [CoinModel]? {
        var coinFetch = FetchDescriptor<CoinModel>(sortBy: [SortDescriptor(\.index)])
        coinFetch.fetchLimit = index + count
        let coins = try? context.fetch(coinFetch)
        print("CoinDataServiceImpl: fetchData: count=\(coins?.count ?? 0)")
        guard let coins, index < coins.count else { return nil }
        
        return Array(coins[index..<min(index + count, coins.count)])
    }
    
    func fetchData(filter: String) async -> [CoinModel]? {
        guard !filter.isEmpty else { return nil }
        do {
            let coinFetch = FetchDescriptor<CoinModel>(
                predicate: #Predicate {
                    $0.name.contains(filter) ||
                    $0.symbol.contains(filter)
                },
                sortBy: [SortDescriptor(\.index)]
            )
            try Task.checkCancellation()
            let coins = try context.fetch(coinFetch)
            try Task.checkCancellation()
            print("CoinDataServiceImpl: fetchData: filter count=\(coins.count)")
            return coins
        } catch {
            print("CoinDataServiceImpl: fetchData: filter nil")
            return nil
        }
    }
    
    @MainActor
    func saveData<T: PersistentModel>(_ coin: T) {
        print("CoinDataServiceImpl: \(#function) type: \(T.self)")
        context.insert(coin)
        save()
    }
    
    @MainActor
    func saveData<T: PersistentModel>(_ coins: [T]) {
        print("CoinDataServiceImpl: \(#function) Start")
        print("--------------------------------------------------")
        for coin in coins {
            // TODO: проверим нужно ли сохранить
            context.insert(coin)
        }
        save()
        // обновим что занесли в базу
        saveInfo(coins.count)
        print("CoinDataServiceImpl: \(#function): Ok \(coins.count)")
        print("--------------------------------------------------")
    }
    
    func updateLogo(by id: String, logo: Data) async {
        let coinFetch = FetchDescriptor<CoinModel>(predicate: #Predicate { coin in
            coin.id == id
        })
        let coins = try? context.fetch(coinFetch)
        if let coin = coins?.first {
            coin.logo = CoinLogoModel(id: id, data: logo)
            context.insert(coin)
            print("CoinDataServiceImpl: \(#function) logo: \(coin.logo?.data)")
            save(true)
        }
    }
    
    // MARK: - CoinDetail
    func fetchData(by id: String) -> CoinDetailModel? {
        print("CoinDataServiceImpl: \(#function)")
        let coinFetch = FetchDescriptor<CoinDetailModel>(predicate: #Predicate { coin in
            coin.id == id
        })
        let coins = try? context.fetch(coinFetch)
        return coins?.first
    }
    
    // MARK: - Logo
    @MainActor
    func fetchLogo(by id: String) async -> CoinLogoModel? {
        print("CoinDataServiceImpl: \(#function)")
        guard await isLogoInitialize() else { return nil }
        
        var logoFetch = FetchDescriptor<CoinLogoModel>(predicate: #Predicate { logo in
            logo.id == id
        })
        logoFetch.fetchLimit = 1
        do {
            let logos = try context.fetch(logoFetch)
            return logos.first
        } catch {
            print("CoinDataServiceImpl: \(#function) error: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func isLogoInitialize() async -> Bool {
        do {
            _ = try context.fetch(FetchDescriptor<CoinLogoModel>())
            return true
        } catch {
            return false
        }
    }
    
    // MARK: - Delete
    @MainActor
    func deleteData<T: PersistentModel>(_ coin: T) {
        context.delete(coin)
        save()
    }
    
    // MARK: - Save
    private func save(_ force: Bool = false) {
        do {
            if force || context.hasChanges {
                try context.save()
                print("CoinDataServiceImpl: \(#function)")
            }
        } catch {
            print("CoinDataServiceImpl: \(#function) error: \(error)")
        }
    }
    
}
