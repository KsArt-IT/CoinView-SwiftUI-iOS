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
    
    // MARK: - Coin
    func fetchData() -> [CoinModel]? {
        let coins = try? context.fetch(FetchDescriptor<CoinModel>())
        print("CoinDataServiceImpl: fetchData: \(coins?.count ?? 0)")
        return coins
    }
    
    @MainActor
    func saveData(_ coin: CoinModel) {
        context.insert(coin)
        save()
    }
    
    @MainActor
    func saveData(_ coins: [CoinModel]) {
        print("CoinDataServiceImpl: \(#function) Start")
        print("--------------------------------------------------")
        for coin in coins {
            // проверим нужно ли сохранить
            context.insert(coin)
        }
        save()
        // обновим что занесли в базу
        saveInfo(coins.count)
        print("CoinDataServiceImpl: \(#function): Ok \(coins.count)")
        print("--------------------------------------------------")
    }
    
    func deleteData(_ coin: CoinModel) {
        context.delete(coin)
        save()
    }
    
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
    
    // MARK: - CoinDetail
    func fetchData(by id: String) -> CoinDetailModel? {
        let coinFetch = FetchDescriptor<CoinDetailModel>(predicate: #Predicate { coin in
            coin.id == id
        })
        let coins = try? context.fetch(coinFetch)
        return coins?.first
    }
    
    func saveData(_ coin: CoinDetailModel) {
        print("CoinDataServiceImpl: \(#function)")
        context.insert(coin)
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
