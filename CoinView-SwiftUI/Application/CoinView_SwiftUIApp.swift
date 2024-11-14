//
//  CoinView_SwiftUIApp.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import SwiftUI

@main
struct CoinView_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        debugPrint(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
