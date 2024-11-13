//
//  DBStorage.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 08.11.2024.
//

import Foundation
import SwiftData

protocol CoinDataService: AnyObject {
    func fetchInfo() -> InfoModel?
    
    func fetchCount<T: PersistentModel>(of entity: T.Type) async -> Int?
    func saveData<T: PersistentModel>(_ coin: T)
    func saveData<T: PersistentModel>(_ coins: [T])
    
    func fetchData() -> [CoinModel]?
    func fetchData(index: Int, count: Int) -> [CoinModel]?
    func updateLogo(by id: String, logo: Data) async

    func fetchData(by id: String) -> CoinDetailModel?
    
    func fetchLogo(by id: String) async -> CoinLogoModel?
}
