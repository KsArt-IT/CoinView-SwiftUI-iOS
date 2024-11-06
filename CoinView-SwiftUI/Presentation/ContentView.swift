//
//  ContentView.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State var splash = true
    @State var selected: Set<CoinDetail> = []
    
    var body: some View {
        if splash {
            SplashScreen(splash: $splash)
        } else {
            NavigationSplitView(columnVisibility: .constant(.all)) {
                MainScreen(selection: $selected)
            } detail: {
                if !selected.isEmpty, let first = selected.first {
                    DetailScreen(coinDetail: first)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
