//
//  MainScreen.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import SwiftUI

struct MainScreen: View {
    @StateObject var viewModel = MainViewModel()
    @Binding var selection: Set<String>
    
    var body: some View {
        VStack {
            List(viewModel.list, selection: $selection) { coin in
                CoinView(coin: coin) {
                    selection = [coin.id]
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
        MainScreen(selection: .constant([]))
    }
}
