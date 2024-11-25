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
    var id: String?
    @Attribute(.externalStorage)
    var data: Data?
    
    init(id: String, data: Data) {
        self.id = id
        self.data = data
    }
}
