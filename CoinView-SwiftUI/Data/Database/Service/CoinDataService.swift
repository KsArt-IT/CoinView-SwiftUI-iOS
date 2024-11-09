//
//  DBStorage.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 08.11.2024.
//

import Foundation

protocol CoinDataService: AnyObject {
    func fetchInfo() -> InfoModel?
    
    func fetchData() -> [CoinModel]?
    func saveData(_ coins: [CoinModel])
    func saveData(_ coin: CoinModel)
    
    func fetchData(by id: String) -> CoinDetailModel?
    func saveData(_ coin: CoinDetailModel)
}
