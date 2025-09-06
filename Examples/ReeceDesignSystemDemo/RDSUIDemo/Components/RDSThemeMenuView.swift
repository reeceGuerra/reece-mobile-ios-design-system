//
//  MenuView.swift
//  RDSDesignSystemDemo
//
//  Created by Carlos Lopez on 01/09/25.
//
import SwiftUI
import RDSUI

struct RDSThemeMenuView: View {
    @Environment(\.rdsTheme) private var themeMode: Binding<RDSThemeMode>
    @Environment(\.colorScheme) private var systemScheme
    
    var body: some View {
        let menuBg: Color =  RDSThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode.wrappedValue) == .dark
        ? Color.white.opacity(0.12)
        : Color.black.opacity(0.08)
        
        let menuBorder: Color = RDSThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode.wrappedValue) == .dark
        ? Color.white.opacity(0.22)
        : Color.black.opacity(0.18)
        
        let menuIcon: String = RDSThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode.wrappedValue) == .dark
        ? "moon.stars.fill"
        : "sun.max.fill"
        let textColor = RDSThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode.wrappedValue) == .dark
        ? Color.white.opacity(0.92)
        : Color.black.opacity(0.9)
        
        Menu {
            ForEach(RDSThemeMode.allCases, id: \.self) { theme in
                Button {
                    themeMode.wrappedValue = theme
                } label: {
                    if themeMode.wrappedValue == theme {
                        Label(theme.title, systemImage: "checkmark")
                    } else {
                        Text(theme.title)
                    }
                }
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: menuIcon)
                Text(themeMode.wrappedValue.title).font(.callout.weight(.semibold))
            }
            .padding(.horizontal, 12).padding(.vertical, 8)
            .foregroundStyle(textColor)
            .background(menuBg)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(menuBorder, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
