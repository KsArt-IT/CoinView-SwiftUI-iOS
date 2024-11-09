//
//  CoinRepository.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 05.11.2024.
//

import Foundation

protocol CoinRepository: AnyObject {
    func fetchCoins() async -> Result<[Coin], any Error>
    func fetchCoinDetail(id: String) async -> Result<CoinDetail, any Error>
    
    func saveData(_ coin: Coin) async
}
