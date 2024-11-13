//
//  Coin.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import Foundation

struct Coin: Identifiable, Hashable {
    public let id: String
    let isActive: Bool
    let name: String
    let rank: Int
    let symbol: String
    let logo: Data?
}

extension Coin {
    static func instance(by name: String) -> Self {
        Coin(
            id: UUID().uuidString,
            isActive: true,
            name: name,
            rank: 0,
            symbol: "-",
            logo: nil
        )
    }
    
    public func copy(logo: Data? = nil) -> Self {
        Coin(
            id: self.id,
            isActive: self.isActive,
            name: self.name,
            rank: self.rank,
            symbol: self.symbol,
            logo: logo
        )
    }
    
//    public func mapToModel() -> CoinModel {
//        CoinModel(
//            id: self.id,
//            isActive: self.isActive,
//            name: self.name,
//            rank: self.rank,
//            symbol: self.symbol,
//            logo: self.logo == nil ? nil : CoinLogoModel(id: self.id, data: self.logo!)
//        )
//    }
}
