//
//  CoinDetailModel.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 09.11.2024.
//

import Foundation
import SwiftData

@Model
final class CoinDetailModel {
    @Attribute(.unique)
    var id: String
    var name: String
    var symbol: String
    var rank: Int
    var isNew: Bool
    var isActive: Bool

    var descript: String
    var firstDataAt: String
    var lastDataAt: String
    var message: String

    var tags: [String]
    var team: [String]

    // Связь с CoinLogoModel
    @Relationship(deleteRule: .nullify)
    var logo: CoinLogoModel?

    init(
        id: String,
        name: String,
        symbol: String,
        rank: Int,
        isNew: Bool,
        isActive: Bool,
        descript: String,
        firstDataAt: String,
        lastDataAt: String,
        message: String,
        tags: [String] = [],
        team: [String] = []
    ) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.rank = rank
        self.isNew = isNew
        self.isActive = isActive
        self.descript = descript
        self.firstDataAt = firstDataAt
        self.lastDataAt = lastDataAt
        self.message = message
        self.tags = tags
        self.team = team
    }
}

extension CoinDetailModel {
    
    func mapToDomain() -> CoinDetail {
        CoinDetail(
            id: self.id,
            name: self.name,
            symbol: self.symbol,
            rank: self.rank,
            isNew: self.isNew,
            isActive: self.isActive,
            logo: self.logo?.data,
            description: self.descript,
            firstDataAt: self.firstDataAt,
            lastDataAt: self.lastDataAt,
            message: self.message,
            tags: self.tags,
            team: self.team
        )
    }
}
