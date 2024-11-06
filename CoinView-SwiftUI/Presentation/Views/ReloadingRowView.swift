//
//  LastRowView.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 05.11.2024.
//

import SwiftUI

struct ReloadingRowView: View {
    @Binding var state: PaginationState
    let reloading: () -> Void
    
    var body: some View {
        VStack {
            switch state {
            case .loading:
                ProgressView()
            case .error(let message):
                HStack {
                    Text(message)
                        .foregroundStyle(Color.red)
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    Button {
                        reloading()
                    } label: {
                        Image(systemName: "arrow.clockwise.circle")
                            .font(.title)
                    }
                    .buttonStyle(.borderless)
                }
            case .none:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, idealHeight: 50, maxHeight: 100)
        .padding(8)
        .background(Color.white.opacity(0.3))
        .cornerRadius(Constants.cornerRadius)
        .listRowInsets(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
        .listRowBackground(Color.clear)
        .task {
            // запускаем загрузку, только если .none
            if case .none = state {
                reloading()
            }
        }
    }
}

#Preview {
    ReloadingRowView(state: .constant(.error(message: "Error"))) {}
}
