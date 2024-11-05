//
//  CoinNetworkService.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 05.11.2024.
//

import Foundation

protocol CoinNetworkService {

    func fetchData<T>(endpoint: CoinEndpoint) async -> Result<T, any Error> where T : Decodable
    func fetchData(url: String) async -> Data?
}

