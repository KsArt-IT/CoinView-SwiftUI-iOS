//
//  MainScreen.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import SwiftUI

struct MainScreen: View {
    @StateObject var viewModel = MainViewModel()
    @Binding var selection: Set<CoinDetail>
    
    var body: some View {
        VStack {
            if viewModel.list.isEmpty {
                List {
                    ReloadingRowView(state: $viewModel.reloadingState) {
                        viewModel.loadData()
                    }
                }
                .listStyle(.plain)
            } else {
                List(viewModel.list, selection: $selection) { coin in
                    CoinView(coin: coin)
                        .onTapGesture {
                            print("select: \(coin.id)")
                            if let coinDetail = viewModel.getCoinDetail(by: coin.id) {
                                selection = [coinDetail]
                            }
                        }
                    // покажем загрузку и догрузим
                    if viewModel.isLastItemAndMoreDataAvailable(coin) {
                        ReloadingRowView(state: $viewModel.reloadingState) {
                            viewModel.loadMoreItems()
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        // MARK: - Navigation
        .navigationTitle("Coins")
        .navigationBarTitleDisplayMode(.inline)
        .background {
            BackgroundView()
        }
    }
}

#Preview {
    NavigationView {
        MainScreen(selection: .constant([]))
    }
}
