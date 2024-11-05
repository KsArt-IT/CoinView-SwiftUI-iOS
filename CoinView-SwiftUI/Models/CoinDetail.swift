//
//  CoinDetail.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 05.11.2024.
//

import Foundation

public struct CoinDetail {
    let id: String
    let name: String
    let symbol: String
    let rank: Int
    let isNew: Bool
    let isActive: Bool

    let logo: String
    
    let description: String
    let firstDataAt: String

    let lastDataAt: String
    let message: String

    let tags: [String]
    let team: [String]
}
