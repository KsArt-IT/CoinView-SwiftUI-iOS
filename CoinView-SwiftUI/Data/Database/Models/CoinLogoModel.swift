//
//  CoinLogoModel.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 09.11.2024.
//

import Foundation
import SwiftData

@Model
final class CoinLogoModel {
    @Attribute(.unique)
    var data: Data

    init(data: Data) {
        self.data = data
    }
}
