//
//  LastRowView.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 05.11.2024.
//

import SwiftUI

struct ReloadingRowView: View {
    @Binding var state: PaginationState
    var first: Bool
    let reloading: () -> Void
    
    var body: some View {
        VStack {
            switch state {
            case .none:
                EmptyView()
            case .reload:
                Color.clear
                    .task {
                        print("ReloadingRowView: reloading")
                        reloading()
                    }
            case .loading:
                VStack {
                    if first {
                        Text("Initial loading, please wait!")
                    }
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .frame(maxWidth: .infinity, idealHeight: 50, maxHeight: 100)
                .padding(8)
                .background(Color.backgroundRow)
                .cornerRadius(Constants.cornerRadius)
            case .error(let message):
                HStack {
                    Text(message)
                        .foregroundStyle(.red)
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
                .background(Color.backgroundRow)
                .cornerRadius(Constants.cornerRadius)
            }
        }
        .listRowInsets(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    VStack {
        List {
            ReloadingRowView(state: .constant(.loading), first: true) {}
        }
    }
}
