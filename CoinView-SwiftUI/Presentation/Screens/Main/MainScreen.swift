//
//  MainScreen.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import SwiftUI

struct MainScreen: View {
    @StateObject private var viewModel = MainViewModel()
    @Binding var appTheme: AppTheme
    @Binding var selection: String?
    
    var body: some View {
        ZStack {
            List(selection: $selection) {
                ForEach(
                    viewModel.search.isEmpty ? viewModel.list : viewModel.listSearch
                ) { coin in
                    CoinView(coin: coin)
                        .onTapGesture {
                            print("select: \(coin.id)")
                            selection = coin.id
                        }
                }
                // покажем загрузку и догрузим или релоад
                if viewModel.search.isEmpty && viewModel.isMoreDataAvailable {
                    ReloadingRowView(state: $viewModel.reloadingState, first: viewModel.isInitialLoading) {
                        viewModel.loadMoreItems()
                    }
                }
            }
            .listStyle(.plain)
            .padding(.bottom, 32)
            if !viewModel.isInitialLoading {
                HStack {
                    VStack {
                        Text(viewModel.countLoaded.description)
                        Text(viewModel.count.description)
                    }
                    .font(.caption)
                    .padding(.horizontal)
                    ProgressView(value: viewModel.progressLoaded)
                        .progressViewStyle(.linear)
                        .padding(.trailing)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        // MARK: - Navigation
        .navigationTitle("Coins")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.isSearchVisible.toggle()
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
            ToolbarItem(placement: .primaryAction) {
                ToolbarMenuView(appTheme: $appTheme)
            }
        }
        .if(!viewModel.isInitialLoading && viewModel.isSearchVisible) {
            $0.searchable(text: $viewModel.search, prompt: Text("Filter on name or symbol"))
        }
        .autocapitalization(.none)
        .background {
            BackgroundView(main: true)
        }
    }
}

#Preview {
    NavigationView {
        MainScreen(appTheme: .constant(AppTheme.light), selection: .constant(nil))
    }
}
