//
//  Info.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 09.11.2024.
//

import Foundation
import SwiftData

@Model
final class InfoModel {
    @Attribute(.unique)
    var id: Int
    var count: Int
    var dateUpdate: Date
    
    init(count: Int) {
        self.id = 0
        self.dateUpdate = Date()
        self.count = count
    }
}
