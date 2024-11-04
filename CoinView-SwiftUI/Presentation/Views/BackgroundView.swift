//
//  BackgroundView.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Image(.mainBackground)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .opacity(0.5)
    }
}

#Preview {
    BackgroundView()
}
