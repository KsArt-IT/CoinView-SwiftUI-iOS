//
//  ContentView.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import SwiftUI

struct ContentView: View {
    // получим тему на устройстве
    @Environment(\.colorScheme) private var colorScheme
    // сохраним-загрузим выбранную тему
    @AppStorage("appTheme") private var appTheme = AppTheme.device

    @State private var splash = true
    @State private var selected: String?
    
    var body: some View {
        Group {
            if splash {
                SplashScreen(splash: $splash)
            } else {
                NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
                    MainScreen(appTheme: $appTheme, selection: $selected)
                } detail: {
                    if let selected {
                        DetailScreen(id: selected)
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
        .preferredColorScheme(appTheme.scheme(colorScheme))
    }
}

#Preview {
    ContentView()
}
