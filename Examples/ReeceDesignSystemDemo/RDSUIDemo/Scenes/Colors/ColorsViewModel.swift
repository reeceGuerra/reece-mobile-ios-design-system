//
//  HomeViewModel.swift
//  RDSDesignSystemDemo
//
//  Created by Carlos Lopez on 30/08/25.
//


import SwiftUI
import RDSUI

@MainActor
final class ColorsViewModel: ObservableObject {
    func backgroundColor(using systemScheme: ColorScheme, andThemeMode themeMode: RDSThemeMode) -> Color {
        RDSThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode) == .dark ? Color(white: 0.30) : Color(white: 0.90)
    }
    func cellBackgroundColor(using systemScheme: ColorScheme, andThemeMode themeMode: RDSThemeMode) -> Color {
        RDSThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode) == .dark ? Color(white: 0.50) : Color.white
    }
    func primaryTextColor(using systemScheme: ColorScheme, andThemeMode themeMode: RDSThemeMode) -> Color {
        RDSThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode) == .dark ? Color.white.opacity(0.92) : Color.black.opacity(0.9)
    }
    func accentColor(using systemScheme: ColorScheme, andThemeMode themeMode: RDSThemeMode) -> Color {
        RDSThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode) == .dark ? Color.white.opacity(0.95) : Color.black.opacity(0.95)
    }
}
