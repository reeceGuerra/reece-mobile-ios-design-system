//
//  HomeViewModel.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 30/08/25.
//


import SwiftUI
import ReeceDesignSystem

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var themeMode: ReeceThemeMode = .system

    // El systemScheme debe venir de la vista
    func effectiveScheme(using systemScheme: ColorScheme) -> ColorScheme {
        switch themeMode {
        case .system: return systemScheme
        case .light:  return .light
        case .dark:   return .dark
        }
    }

    // Derivados de UI (pasan systemScheme para resolver)
    func backgroundColor(using systemScheme: ColorScheme) -> Color {
        effectiveScheme(using: systemScheme) == .dark ? Color(white: 0.30) : Color(white: 0.90)
    }
    func cellBackgroundColor(using systemScheme: ColorScheme) -> Color {
        effectiveScheme(using: systemScheme) == .dark ? Color(white: 0.50) : Color.white
    }
    func primaryTextColor(using systemScheme: ColorScheme) -> Color {
        effectiveScheme(using: systemScheme) == .dark ? Color.white.opacity(0.92) : Color.black.opacity(0.9)
    }
    func accentColor(using systemScheme: ColorScheme) -> Color {
        effectiveScheme(using: systemScheme) == .dark ? Color.white.opacity(0.95) : Color.black.opacity(0.95)
    }
    func menuLabelBackground(using systemScheme: ColorScheme) -> Color {
        effectiveScheme(using: systemScheme) == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.08)
    }
    func menuLabelBorder(using systemScheme: ColorScheme) -> Color {
        effectiveScheme(using: systemScheme) == .dark ? Color.white.opacity(0.22) : Color.black.opacity(0.18)
    }
    func imageThemeSystem(using systemScheme: ColorScheme) -> String {
        effectiveScheme(using: systemScheme) == .dark ? "moon.stars.fill" : "sun.max.fill"
    }
    
    func applyThemeSideEffects() {
        ReeceTheme.mode = themeMode
    }
}
