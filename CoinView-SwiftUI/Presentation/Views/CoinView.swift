//
//  CoinView.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import SwiftUI

struct CoinView: View {
    let coin: Coin
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            CoinImageView(data: coin.logo)
                .frame(height: 50)
            VStack(alignment: .leading, spacing: 4) {
                Text(coin.name)
                    .font(.title)
                    .lineLimit(1)
                Text("\(coin.rank) (\(coin.symbol))")
                    .font(.subheadline)
                    .lineLimit(2)
            }
            Spacer()
            Image(systemName: "info.bubble")
        }
        .padding(8)
        .background(Color.white.opacity(0.3))
        .cornerRadius(Constants.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(coin.isActive ? .green : .clear, lineWidth: 1)
        )
        .onTapGesture {
            action()
        }
        .listRowInsets(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
        .listRowBackground(Color.clear)
    }
}

#Preview {
    CoinView(coin: Coin.instance(by: "Frt")) {}
}
