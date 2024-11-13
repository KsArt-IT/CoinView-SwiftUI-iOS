//
//  MainScreen.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import SwiftUI

struct MainScreen: View {
    @StateObject var viewModel = MainViewModel()
    @Binding var selection: String?
    
    var body: some View {
        ZStack {
            List(selection: $selection) {
                if viewModel.search.isEmpty {
                    ForEach(viewModel.list) { coin in
                        CoinView(coin: coin)
                            .onTapGesture {
                                print("select: \(coin.id)")
                                selection = coin.id
                            }
                    }
                    // покажем загрузку и догрузим или релоад
                    if viewModel.search.isEmpty && viewModel.isMoreDataAvailable {
                        ReloadingRowView(state: $viewModel.reloadingState) {
                            viewModel.loadMoreItems()
                        }
                    }
                } else {
                    ForEach(viewModel.listSearch) { coin in
                        CoinView(coin: coin)
                            .onTapGesture {
                                print("select: \(coin.id)")
                                selection = coin.id
                            }
                    }
                }
            }
            .listStyle(.plain)
            .padding(.bottom, 24)
            HStack {
                Text(viewModel.countLoaded.description)
                    .frame(width: 60)
                    .padding(.horizontal)
                ProgressView(value: viewModel.progressLoaded)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding(.trailing)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        // MARK: - Navigation
        .navigationTitle("Coins")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $viewModel.search)
        .autocapitalization(.none)
        .background {
            BackgroundView(main: true)
        }
    }
}

#Preview {
    NavigationView {
        MainScreen(selection: .constant(nil))
    }
}
