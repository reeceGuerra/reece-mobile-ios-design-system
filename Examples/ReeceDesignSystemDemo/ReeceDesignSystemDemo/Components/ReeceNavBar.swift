//
//  ReeceTopBar.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 31/08/25.
//


import SwiftUI
import ReeceDesignSystem

struct ReceThemeKey: EnvironmentKey {
    static let defaultValue:Binding<ReeceThemeMode> = .constant(.system)
}

struct ReeceRouteKey: EnvironmentKey {
    static let defaultValue: ReeceRoute = .home
}

extension EnvironmentValues {
    var reeceTheme: Binding<ReeceThemeMode> {
        get { self[ReceThemeKey.self] }
        set { self[ReceThemeKey.self] = newValue }
    }
    
    var reeceRoute: ReeceRoute {
        get { self[ReeceRouteKey.self] }
        set { self[ReeceRouteKey.self] = newValue }
    }
}

/// Top bar propio (no usa UINavigationBar).
/// - Muestra título a la izquierda.
/// - Botón Back opcional (aparece cuando hay algo en el router.path).
/// - Menú de theme a la derecha, usando tu HomeViewModel.
/// - Colores reactivos al scheme efectivo.
struct ReeceNavBar<Leading: View, Trailing: View>: View {
    @Environment(\.colorScheme) private var systemScheme
    @Environment(\.reeceTheme) private var themeMode: Binding<ReeceThemeMode>
    @Environment(\.reeceRoute) private var router: ReeceRoute
    
    let title: String
    let showBack: Bool
    let leading: Leading
    let trailing: Trailing
    var overrideBackground: Color? = nil
    let onBack: () -> Void
    
    // Derivados de UI (idénticos a tu toolbar previo)
    private var backgroundColor: Color {
        ReeceThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode.wrappedValue) == .dark
        ? Color(white: 0.30)
        : Color(white: 0.90)
    }
    private var textColor: Color {
        ReeceThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode.wrappedValue) == .dark
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
