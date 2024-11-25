//
//  ToolbarMenuView.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 25.11.2024.
//

import SwiftUI

struct ToolbarMenuView: View {
    @Binding var appTheme: AppTheme
    
    var body: some View {
        Menu {
            Section("Theme:") {
                Button {
                    appTheme = .device
                } label: {
                    Label(
                        "Device",
                        systemImage: appTheme == .device ? "checkmark.circle" : "circle"
                    )
                }
                Button {
                    appTheme = .light
                } label: {
                    Label(
                        "Light",
                        systemImage: appTheme == .light ? "checkmark.circle" : "circle"
                    )
                }
                Button {
                    appTheme = .dark
                } label: {
                    Label(
                        "Dark",
                        systemImage: appTheme == .dark ? "checkmark.circle" : "circle"
                    )
                }
            }
        } label: {
            Label("Options", systemImage: "ellipsis.circle")
        }
    }
}
