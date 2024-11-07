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
                        .frame(maxWidth: .infinity, idealHeight: 50, maxHeight: 100)
                        .padding(8)
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(Constants.cornerRadius)
            case .error(let message):
                HStack {
                    Text(message)
                        .foregroundStyle(Color.red)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 500)
                    Spacer()
                    Button {
                        print("ReloadingRowView: Button reloading")
                        reloading()
                    } label: {
                        Image(systemName: "arrow.clockwise.circle")
                            .font(.title)
                    }
                    .buttonStyle(.borderless)
                }
                .padding(8)
                .background(Color.white.opacity(0.3))
                .cornerRadius(Constants.cornerRadius)
            case .none:
                //EmptyView() // тут не подходит, не происходит дозагрузка
                Color.clear
                    .task {
                        print("ReloadingRowView: reloading")
                        reloading()
                    }
            }
        }
        .listRowInsets(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    ReloadingRowView(state: .constant(.error(message: "Error"))) {}
}
