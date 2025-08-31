//
//  ReeceToolbarModifier.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 31/08/25.
//


import SwiftUI
import ReeceDesignSystem

/// Toolbar reutilizable con título a la izquierda y menú de tema a la derecha.
/// - Usa el HomeViewModel para colores, iconos e integración de theme.
/// - Se puede ocultar con visible=false.
struct ReeceToolbarModifier: ViewModifier {
    @Environment(\.colorScheme) private var systemScheme
    @EnvironmentObject private var vm: HomeViewModel

    let title: String
    let visible: Bool

    private var textColor: Color { vm.primaryTextColor(using: systemScheme) }
    private var menuBg: Color { vm.menuLabelBackground(using: systemScheme) }
    private var menuBorder: Color { vm.menuLabelBorder(using: systemScheme) }
    private var menuIcon: String { vm.imageThemeSystem(using: systemScheme) }

    func body(content: Content) -> some View {
        content
            .toolbar {
                if visible {
                    ToolbarItem(placement: .topBarLeading) {
                        Text(title)
                            .font(.title)
                            .foregroundStyle(textColor)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            ForEach(ReeceThemeMode.allCases, id: \.self) { theme in
                                Button { vm.themeMode = theme } label: {
                                    Label(theme.title,
                                          systemImage: vm.themeMode == theme ? "checkmark" : "")
                                }
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: menuIcon)
                                Text(vm.themeMode.title)
                                    .font(.callout.weight(.semibold))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .foregroundStyle(textColor)
                            .background(menuBg)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(menuBorder, lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
    }
}

extension View {
    /// Aplica el toolbar compartido con título y visibilidad opcional.
    func reeceToolbar(title: String, visible: Bool = true) -> some View {
        modifier(ReeceToolbarModifier(title: title, visible: visible))
    }
}
