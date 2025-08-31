//
//  ReeceDemoThemeEnvironment.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 31/08/25.
//


import SwiftUI

// MARK: - Environment Keys

private struct ReeceBackgroundKey: EnvironmentKey {
    static let defaultValue: Color? = nil   // si no hay valor, no forzamos fondo
}

private struct ReeceCellBackgroundKey: EnvironmentKey {
    static let defaultValue: Color? = nil
}

public extension EnvironmentValues {
    /// Background temático heredable por la jerarquía de vistas.
    var reeceBackground: Color? {
        get { self[ReeceBackgroundKey.self] }
        set { self[ReeceBackgroundKey.self] = newValue }
    }
    /// Background para filas de listas (listRowBackground) heredable.
    var reeceCellBackground: Color? {
        get { self[ReeceCellBackgroundKey.self] }
        set { self[ReeceCellBackgroundKey.self] = newValue }
    }
}

// MARK: - View helpers

public extension View {
    /// Inyecta un background temático en el environment.
    func reeceBackground(_ color: Color?) -> some View {
        environment(\.reeceBackground, color)
    }
    /// Inyecta un background para filas de listas en el environment.
    func reeceCellBackground(_ color: Color?) -> some View {
        environment(\.reeceCellBackground, color)
    }

    /// Aplica el background temático heredado (si existe) a esta vista.
    /// Útil en contenedores/pantallas hijas para no repetir `.background(...)`.
    func applyThemedBackground() -> some View {
        modifier(_ReeceApplyThemedBackground())
    }

    /// Aplica el background temático de filas heredado a un `List`.
    func applyThemedListRowBackground() -> some View {
        modifier(_ReeceApplyThemedListRowBackground())
    }
}

// MARK: - Internal modifiers

private struct _ReeceApplyThemedBackground: ViewModifier {
    @Environment(\.reeceBackground) private var bg
    func body(content: Content) -> some View {
        if let bg { content.background(bg) } else { content }
    }
}

private struct _ReeceApplyThemedListRowBackground: ViewModifier {
    @Environment(\.reeceCellBackground) private var cellBg
    func body(content: Content) -> some View {
        if let cellBg { content.listRowBackground(cellBg) } else { content }
    }
}
