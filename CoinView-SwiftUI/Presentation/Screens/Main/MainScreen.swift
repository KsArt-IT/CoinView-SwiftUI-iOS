//
//  MainScreen.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import SwiftUI

struct MainScreen: View {
    @StateObject var viewModel = MainViewModel()
    @Binding var selection: CoinDetail?
    
    var body: some View {
        VStack {
            List(selection: $selection) {
                ForEach(viewModel.list) { coin in
                    CoinView(coin: coin)
                        .onTapGesture {
                            if let coinDetail = viewModel.getCoinDetail(by: coin.id) {
                                print("select: \(coin.id)")
                                selection = coinDetail
                            }
                        }
                }
                // покажем загрузку и догрузим или релоад
                if viewModel.isMoreDataAvailable {
                    ReloadingRowView(state: $viewModel.reloadingState) {
                        viewModel.loadMoreItems()
                    }
                }
            }
            .listStyle(.plain)
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
        MainScreen(selection: .constant(nil))
    }
}
