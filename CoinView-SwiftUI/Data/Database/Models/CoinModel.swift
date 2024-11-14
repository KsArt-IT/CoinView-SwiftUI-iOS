//
//  Coin.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 08.11.2024.
//

import Foundation
import SwiftData

@Model
final class CoinModel {
    @Attribute(.unique)
    var index: Int
    @Attribute(.unique)
    var id: String
    var isActive: Bool
    var name: String
    var rank: Int
    var symbol: String
    
    // Связь с CoinLogoModel
    @Relationship(deleteRule: .nullify)
    var logo: CoinLogoModel?
    
    init(index: Int, id: String, isActive: Bool, name: String, rank: Int, symbol: String, logo: CoinLogoModel? = nil) {
        self.index = index
        self.id = id
        self.isActive = isActive
        self.name = name
        self.rank = rank
        self.symbol = symbol
        self.logo = logo
    }
}

extension CoinModel {
    
    func mapToDomain(logo: Data? = nil) -> Coin {
        Coin(
            id: self.id,
            isActive: self.isActive,
            name: self.name,
            rank: self.rank,
            symbol: self.symbol,
            logo: logo != nil ? logo : self.logo == nil ? nil : self.logo?.data
        )
    }
    
}
