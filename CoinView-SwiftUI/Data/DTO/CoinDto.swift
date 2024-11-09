//
//  CoinDto.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 05.11.2024.
//

import Foundation

struct CoinDto: Decodable {
    let id: String
    let isActive: Bool
    let isNew: Bool
    let name: String
    let rank: Int
    let symbol: String
    let type: String
}

extension CoinDto {
    
    func mapToDomain(_ logo: Data? = nil) -> Coin {
        Coin(
            id: self.id,
            isActive: self.isActive,
            name: self.name,
            rank: self.rank,
            symbol: self.symbol,
            logo: logo
        )
    }

    func mapToModel() -> CoinModel {
        CoinModel(
            id: self.id,
            isActive: self.isActive,
            name: self.name,
            rank: self.rank,
            symbol: self.symbol,
            logo: nil
        )
    }
}
