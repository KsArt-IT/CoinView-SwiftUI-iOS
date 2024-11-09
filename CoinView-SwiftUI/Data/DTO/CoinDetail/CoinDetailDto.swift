//
//  CoinDetailDto.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 05.11.2024.
//

import Foundation

struct CoinDetailDto: Decodable {
    let id: String
    let name: String
    let symbol: String
    let rank: Int
    let isNew: Bool
    let isActive: Bool
    let type: String?
    let contract: String?
    let logo: String?
    let platform: String?
    let description: String
    let developmentStatus: String?
    let firstDataAt: String?
    let hardwareWallet: Bool
    let hashAlgorithm: String?
    let lastDataAt: String?
    let message: String?
    let openSource: Bool
    let orgStructure: String?
    let proofType: String?
    let startedAt: String?
    let tags: [CoinTagDto]
    let team: [CoinTeamMemberDto]
    let whitepaper: CoinWhitepaperDto
}

extension CoinDetailDto {

    func mapToDomain(_ logo: Data? = nil) -> CoinDetail {
        CoinDetail(
            id: self.id,
            name: self.name,
            symbol: self.symbol,
            rank: self.rank,
            isNew: self.isNew,
            isActive: self.isActive,
            logo: logo,
            description: self.description,
            firstDataAt: self.firstDataAt ?? "",
            lastDataAt: self.lastDataAt ?? "",
            message: self.message ?? "",
            tags: self.tags.map { $0.name },
            team: self.team.map { "\($0.name) - \($0.position)" }
        )
    }

    func mapToModel(_ logo: Data? = nil) -> CoinDetailModel {
        CoinDetailModel(
            id: self.id,
            name: self.name,
            symbol: self.symbol,
            rank: self.rank,
            isNew: self.isNew,
            isActive: self.isActive,
            descript: self.description,
            firstDataAt: self.firstDataAt ?? "",
            lastDataAt: self.lastDataAt ?? "",
            message: self.message ?? "",
            tags: self.tags.map { $0.name },
            team: self.team.map { "\($0.name) - \($0.position)" },
            logo: logo == nil ? nil : CoinLogoModel(id: self.id, data: logo!)
        )
    }
}
