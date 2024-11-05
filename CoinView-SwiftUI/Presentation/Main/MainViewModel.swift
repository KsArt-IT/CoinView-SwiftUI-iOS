//
//  MainViewModel.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import Foundation

final class MainViewModel: ObservableObject {
    private let repository: CoinRepository? = ServiceLocator.shared.resolve()
    
    @Published var list:[Coin] = [Coin.instance(by: "Btc"),Coin.instance(by: "Neo"),Coin.instance(by: "Lc"),Coin.instance(by: "Scam")]

}
