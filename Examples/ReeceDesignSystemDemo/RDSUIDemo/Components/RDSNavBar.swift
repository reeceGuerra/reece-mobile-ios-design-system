//
//  RDSTopBar.swift
//  RDSDesignSystemDemo
//
//  Created by Carlos Lopez on 31/08/25.
//


import SwiftUI
import RDSUI

struct RDSThemeKey: EnvironmentKey {
    static let defaultValue:Binding<RDSThemeMode> = .constant(.system)
}

struct RDSRouteKey: EnvironmentKey {
    static let defaultValue: RDSRoute = .home
}

extension EnvironmentValues {
    var rdsTheme: Binding<RDSThemeMode> {
        get { self[RDSThemeKey.self] }
        set { self[RDSThemeKey.self] = newValue }
    }
    
    var rdsRoute: RDSRoute {
        get { self[RDSRouteKey.self] }
        set { self[RDSRouteKey.self] = newValue }
    }
}

/// Top bar propio (no usa UINavigationBar).
/// - Muestra título a la izquierda.
/// - Botón Back opcional (aparece cuando hay algo en el router.path).
/// - Menú de theme a la derecha, usando tu HomeViewModel.
/// - Colores reactivos al scheme efectivo.
struct RDSNavBar<Leading: View, Trailing: View>: View {
    @Environment(\.colorScheme) private var systemScheme
    @Environment(\.rdsTheme) private var themeMode: Binding<RDSThemeMode>
    @Environment(\.rdsRoute) private var router: RDSRoute
    
    let title: String
    let showBack: Bool
    let leading: Leading
    let trailing: Trailing
    var overrideBackground: Color? = nil
    let onBack: () -> Void
    
    // Derivados de UI (idénticos a tu toolbar previo)
    private var backgroundColor: Color {
        RDSThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode.wrappedValue) == .dark
        ? Color(white: 0.30)
        : Color(white: 0.90)
    }
    private var textColor: Color {
        RDSThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode.wrappedValue) == .dark
        ? Color.white.opacity(0.92)
        : Color.black.opacity(0.9)
    }
    
    init(
        title: String,
        showBack: Bool = true,
        overrideBackground: Color? = nil,
        @ViewBuilder leading: () -> Leading = { EmptyView() },
        @ViewBuilder trailing: () -> Trailing = { EmptyView() },
        onBack: @escaping () -> Void
    ) {
        self.title = title
        self.showBack = showBack
        self.overrideBackground = overrideBackground
        self.leading = leading()
        self.trailing = trailing()
        self.onBack = onBack
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(overrideBackground ?? backgroundColor)
                .ignoresSafeArea(edges: .top)
                .overlay(Divider(), alignment: .bottom)
            
            HStack(spacing: 12) {
                leading
                
                if showBack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(textColor)
                    }
                }
                
                Text(title)
                    .font(.headline)
                    .foregroundStyle(textColor)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                trailing
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .background(overrideBackground ?? backgroundColor)
        }
        .frame(height: 56)
    }
}
