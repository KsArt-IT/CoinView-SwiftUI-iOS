//
//  Constants.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import Foundation

enum Constants {
    // Название приложения из Bundle
    static let appName: String = {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
        Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Coin  View"
    }()

    static let cornerRadius: CGFloat = 10
}
