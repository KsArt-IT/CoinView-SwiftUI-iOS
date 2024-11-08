//
//  ContentView.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State var splash = true
    @State var selected: CoinDetail?
    
    var body: some View {
        if splash {
            SplashScreen(splash: $splash)
        } else {
            NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
                MainScreen(selection: $selected)
            } detail: {
                if let selected {
                    DetailScreen(coinDetail: selected)
                } else {
                    Text("Select coin\nfrom the list")
                        .font(.largeTitle)
                        .padding(.leading, 32)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background {
                            BackgroundView(main: false)
                        }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
