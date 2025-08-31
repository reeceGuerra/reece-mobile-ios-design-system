//
//  ContentView.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 30/08/25.
//

import SwiftUI
import ReeceDesignSystem

private extension ReeceThemeMode {
    var title: String {
        switch self {
        case .system: return "System"
        case .light:  return "Light"
        case .dark:   return "Dark"
        }
    }
}

struct HomeView: View {
    @Environment(\.colorScheme) private var systemScheme
    @State private var themeMode: ReeceThemeMode = .system
    
    // scheme efectivo (lo que realmente verá la UI)
    private var effectiveScheme: ColorScheme {
        switch themeMode {
        case .system: return systemScheme
        case .light:  return .light
        case .dark:   return .dark
        }
    }
    
    // fondo según el scheme efectivo (bien contrastado y “de app de catálogo”)
    private var backgroundColor: Color {
        effectiveScheme == .dark
        ? Color(white: 0.30)        // casi negro
        : Color(white: 0.90)        // gris muy claro
    }
    
    private var cellBackgroundColor: Color {
        effectiveScheme == .dark
        ? Color(white: 0.50)        // casi negro
        : Color(white: 1)        // gris muy claro
    }
    
    private var imageThemeSystem: String {
        effectiveScheme == .dark
        ? "moon.stars.fill"
        : "sun.max.fill"
    }
    
    // Texto principal según tema
    private var primaryTextColor: Color {
        effectiveScheme == .dark ? Color.white.opacity(0.92) : Color.black.opacity(0.9)
    }
    
    // Color de acento (enlaces, toggles, etc.)
    private var accentColor: Color {
        effectiveScheme == .dark ? Color.white.opacity(0.95) : Color.black.opacity(0.95)
    }
    
    // Fondo del "botón" del menú (la etiqueta visible en toolbar)
    private var menuLabelBackground: Color {
        effectiveScheme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.08)
    }
    
    // Borde sutil del botón del menú
    private var menuLabelBorder: Color {
        effectiveScheme == .dark ? Color.white.opacity(0.22) : Color.black.opacity(0.18)
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("FAMILIES") {
                    NavigationLink("Primary") {
                        PrimaryView(mode: $themeMode, systemScheme: systemScheme)
                    }
                }
                .listRowBackground(cellBackgroundColor)
            }
            .listStyle(.insetGrouped)
            .foregroundStyle(effectiveScheme == .dark ? Color.white : Color.black)
            .tint(effectiveScheme == .dark ? .white : .black)
            .toolbar {
                
                
                ToolbarItem(placement: .topBarLeading) {
                    VStack(spacing: 2) {
                        Text("Reece DS")
                            .font(.title)
                            .foregroundStyle(primaryTextColor)
                    }
                }
                
                // Right-aligned button
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            themeMode = .system
                        } label: { Label("System", systemImage: themeMode == .system ? "checkmark" : "") }
                        
                        Button {
                            themeMode = .light
                        } label: { Label("Light", systemImage: themeMode == .light ? "checkmark" : "") }
                        
                        Button {
                            themeMode = .dark
                        } label: { Label("Dark", systemImage: themeMode == .dark ? "checkmark" : "") }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: imageThemeSystem)
                            Text(themeMode.title)
                                .font(.callout.weight(.semibold))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .foregroundStyle(primaryTextColor)
                        .background(menuLabelBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(menuLabelBorder, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(backgroundColor)
        }
        .preferredColorScheme(effectiveScheme)
        .toolbarBackground(backgroundColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(effectiveScheme, for: .navigationBar)
        .onChange(of: themeMode) { _, newValue in
            ReeceTheme.mode = newValue
        }
    }
}



#Preview {
    HomeView()
}
