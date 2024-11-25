//
//  AppTheme.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 25.11.2024.
//

import SwiftUICore

enum AppTheme: Int {
    case device
    case light
    case dark
}

extension AppTheme {
    // заполним при запуске
    static var deviceTheme: ColorScheme?
    
    private var scheme: ColorScheme {
        switch self {
        case .device:
            Self.deviceTheme ?? .light
        case .light:
                .light
        case .dark:
                .dark
        }
    }
    
    func scheme(_ scheme: ColorScheme) -> ColorScheme {
        // сохраним значение на устройстве
        if Self.deviceTheme == nil {
            Self.deviceTheme = scheme
        }
        return self.scheme
    }
}