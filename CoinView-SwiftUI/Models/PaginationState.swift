//
//  PaginationState.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 05.11.2024.
//

import Foundation

enum PaginationState {
    case none
    case loading
    case reload
    case error(message: String)
}
