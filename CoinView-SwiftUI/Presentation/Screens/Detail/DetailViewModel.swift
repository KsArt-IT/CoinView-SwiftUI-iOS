//
//  DetailViewModel.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 11.11.2024.
//

import Foundation

final class DetailViewModel: ObservableObject {
    private let repository: CoinRepository? = ServiceLocator.shared.resolve()

    @Published var coinDetail: CoinDetail?
    
    public func getCoinDetail(by id: String) {
        guard !id.isEmpty else { return }
        
        Task { [weak self] in
            let result = await self?.repository?.fetchCoinDetail(by: id)
            switch result {
            case .success(let coinDetail):
                await self?.setCoin(coinDetail)
            case .failure(let error):
                print("DetailViewModel: error: \(error.localizedDescription)")
                break
            case .none:
                break
            }
        }
    }
    
    @MainActor
    private func setCoin(_ coinDetail: CoinDetail) {
        self.coinDetail = coinDetail
    }
}
