//
//  ColorDetailView.swift
//  RDSDesignSystemDemo
//
//  Created by Carlos Lopez on 31/08/25.
//


import SwiftUI
import RDSUI

/// Vista detalle tipo "Pantone card".
/// Muestra un bloque de color a pantalla completa con:
/// - Encabezado "RDSDS COLORS"
/// - HEX del color (resuelto por scheme)
/// - Nombre + tono (e.g. "DarkBlue Tone 10")

struct ColorDetailView: View {
    @Environment(\.colorScheme) private var systemScheme
    @State private var appeared = false

    let title: String
    let color: Color
    private var labelColor: Color {
        RDSColorContrast.onColor(for: color, scheme: systemScheme)
    }
    private var hexText: String {
        RDSColorExport.hexString(for: color, scheme: systemScheme, includeAlpha: false) ?? "#N/A"
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            color.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 8) {
                Text("REECE DS COLORS")
                    .font(.title2.weight(.bold))
                    .kerning(0.5)
                Text(hexText)
                    .font(.headline)
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .opacity(0.9)
            }
            .foregroundStyle(labelColor)
            .padding(.horizontal, 20)
            .padding(.bottom, 28)
            .opacity(appeared ? 1 : 0)
            .animation(.easeInOut(duration: 0.40), value: appeared)
        }
        .onAppear { appeared = true }
        .reeceNavigationBar(title: "", overrideBackground: color, trailing: {
            RDSThemeMenuView()
        })
    }
}
