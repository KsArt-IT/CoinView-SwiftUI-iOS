//
//  ErrorMsg.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 07.11.2024.
//

import Foundation

struct ErrorMsg: Decodable {
    let type: String
    let hardLimit: String
    let softLimit: String
    let error: String
    let blockDuration: String
}
