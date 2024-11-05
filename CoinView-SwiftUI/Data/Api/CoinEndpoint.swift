//
//  CoinEndpoint.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 05.11.2024.
//

import Foundation

enum CoinEndpoint {
    case coins
    case coin(id: String)
}

extension CoinEndpoint {
    var url: URL? {
        switch self {
        case .coins:
            return URL(string: "\(Self.baseURL)/coins")
        case .coin(let id):
            return URL(string: "\(Self.baseURL)/coins/\(id)")
        }
    }

    private static let baseURL = "https://api.coinpaprika.com/v1"
}
