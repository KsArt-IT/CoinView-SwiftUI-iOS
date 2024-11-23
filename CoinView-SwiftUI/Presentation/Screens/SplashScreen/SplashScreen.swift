//
//  LaunchScreen.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import SwiftUI

struct SplashScreen: View {
    @Binding var splash: Bool
    @State var scale: CGFloat = 0.8
    let time: Double = 1
    
    var body: some View {
        VStack {
            Spacer()
            Image(.logoApp)
                .resizable()
                .scaledToFit()
                .scaleEffect(scale, anchor: .center)
            Text(Constants.appName)
                .font(.title)
                .foregroundStyle(Color.blue)
                .opacity(scale > 1 ? 0 : 1)
                .padding(.top)
            Spacer()
            Text("KsArT.pro")
                .font(.caption)
        }
        .onAppear {
            withAnimation(.easeOut(duration: time)) {
                scale = 0.3
            }
            withAnimation(.easeIn(duration: time * 2).delay(time)) {
                scale = 4
                splash = false
            }
        }
    }
}

#Preview {
    @Previewable @State var splash = true
    SplashScreen(splash: $splash)
}
