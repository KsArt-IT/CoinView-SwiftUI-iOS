//
//  CoinRepository.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 05.11.2024.
//

import Foundation

protocol CoinRepository: AnyObject {
    func fetchData() async -> Result<Int, any Error>
    func fetchCoins(index: Int, count: Int) async -> Result<[Coin], any Error>
    func fetchCoins(filter: String) async -> Result<[Coin], any Error>
    
    func fetchCoinDetail(by id: String) async -> Result<CoinDetail, any Error>
}
