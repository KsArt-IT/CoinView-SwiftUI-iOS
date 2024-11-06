//
//  ProfileImage.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 04.11.2024.
//

import SwiftUI

struct CoinImageView: View {
    let data: Data?
    
    var body: some View {
        if let data, let image = UIImage(data: data)?.cgImage {
            Image(decorative: image, scale: 1.0, orientation: .up)
                .resizable()
                .scaledToFit()
        } else {
            Image(.coin)
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    CoinImageView(data: nil)
}
