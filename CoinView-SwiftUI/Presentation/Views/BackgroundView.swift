//
//  BackgroundView.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import SwiftUI

struct BackgroundView: View {
    let main: Bool
    
    var body: some View {
        Image(main ? .mainBackground : .detailBackground)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .opacity(0.5)
    }
}

#Preview {
    BackgroundView(main: true)
}
