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
    static func instance(by name: String) -> Coin {
        Coin(
            id: UUID().uuidString,
            isActive: true,
            name: name,
            rank: 0,
            symbol: "-",
            logo: nil
        )
    }
}
