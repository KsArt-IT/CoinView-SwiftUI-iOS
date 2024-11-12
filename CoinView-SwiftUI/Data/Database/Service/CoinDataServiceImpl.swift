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
                for: InfoModel.self, CoinModel.self, CoinDetailModel.self,
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
        let coinFetch = FetchDescriptor<CoinModel>()
        let coins = try? context.fetch(coinFetch)
        print("CoinDataServiceImpl: fetchData: count=\(coins?.count ?? 0)")
        guard let coins, index < coins.count else { return nil }
        
        return Array(coins[index..<min(index + count, coins.count)])
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
    
    // MARK: - CoinDetail
    func fetchData(by id: String) -> CoinDetailModel? {
        let coinFetch = FetchDescriptor<CoinDetailModel>(predicate: #Predicate { coin in
            coin.id == id
        })
        let coins = try? context.fetch(coinFetch)
        return coins?.first
    }
    
    // MARK: - Logo
    func fetchLogo(by id: String) -> CoinLogoModel? {
        let logoFetch = FetchDescriptor<CoinLogoModel>(predicate: #Predicate { logo in
            logo.id == id
        })
        let logos = try? context.fetch(logoFetch)
        return logos?.last
    }
    
    // MARK: - Delete
    @MainActor
    func deleteData<T: PersistentModel>(_ coin: T) {
        context.delete(coin)
        save()
    }
    
    // MARK: - Save
    private func save() {
        do {
            try context.save()
        } catch {
            print("CoinDataServiceImpl: save error: \(error)")
        }
    }

}
