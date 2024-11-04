//
//  LaunchScreen.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import SwiftUI

struct SplashScreen: View {
    @Binding var splash: Bool

    var body: some View {
        VStack {
            Spacer()
            Image(.logoApp)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
            Text("Coin View")
                .font(.title)
                .foregroundStyle(Color.blue)
                .padding(.top)
            Spacer()
            Text("KsArT.pro")
                .font(.caption)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                splash = false
            }
        }
    }
}

#Preview {
    @Previewable @State var splash = true
    SplashScreen(splash: $splash)
}
