//
//  ContentView.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State var splash = true
    
    var body: some View {
        if splash {
            SplashScreen(splash: $splash)
        } else {
            NavigationSplitView {
                EmptyView()
            } detail: {
                EmptyView()
            }
        }
    }
}

#Preview {
    ContentView()
}
