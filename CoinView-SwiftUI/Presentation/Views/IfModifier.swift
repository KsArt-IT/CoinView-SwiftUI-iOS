//
//  IfModifier.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 23.11.2024.
//

import SwiftUI

extension View {
    // Утилита для условного применения модификатора
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, modify: (Self) -> Content) -> some View {
        if condition {
            modify(self)
        } else {
            self
        }
    }
}
