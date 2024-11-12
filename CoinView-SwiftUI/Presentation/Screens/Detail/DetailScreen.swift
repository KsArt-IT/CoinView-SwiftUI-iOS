//
//  DetailScreen.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 06.11.2024.
//

import SwiftUI

struct DetailScreen: View {
    @StateObject var viewModel = DetailViewModel()
    
    let id: String
    
    var body: some View {
        ZStack {
            if let coinDetail = viewModel.coinDetail {
                ScrollView {
                    
                    CoinImageView(data: coinDetail.logo)
                        .frame(height: 150)
                        .overlay {
                            Circle()
                                .stroke(coinDetail.isActive ? .green : .gray, lineWidth: 2)
                        }
                    Text(coinDetail.symbol)
                    Divider()
                    HStack {
                        Text("First date:")
                        Text(coinDetail.firstDataAt)
                    }
                    HStack {
                        Text("Last date:")
                        Text(coinDetail.lastDataAt)
                    }
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Team")
                            .font(.title2)
                        Text(coinDetail.team.joined(separator: "\n"))
                        Divider()
                        
                        Text("Tags")
                            .font(.title2)
                        Text(coinDetail.tags.joined(separator: "\n"))
                        Divider()
                        
                        Text("Message")
                            .font(.title2)
                        Text(coinDetail.message.isEmpty ? coinDetail.description : coinDetail.message)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .task {
                        viewModel.getCoinDetail(by: id)
                    }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.coinDetail?.name ?? id)
        .background {
            BackgroundView(main: false)
        }
    }
}

#Preview {
    NavigationView {
                DetailScreen(id: "")
    }
}
