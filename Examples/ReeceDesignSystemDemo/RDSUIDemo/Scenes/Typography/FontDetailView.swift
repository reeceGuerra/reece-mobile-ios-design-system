//
//  FontDetailView.swift
//  RDSDesignSystemDemo
//
//  Created by Carlos Lopez on 03/09/25.
//


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

#if canImport(UIKit)
import UIKit
private func ds_availableFontFamilies() -> [String] { UIFont.familyNames.sorted() }
private func ds_fontNames(for family: String) -> [String] { UIFont.fontNames(forFamilyName: family).sorted() }
#elseif canImport(AppKit)
import AppKit
private func ds_availableFontFamilies() -> [String] { NSFontManager.shared.availableFontFamilies.sorted() }
private func ds_fontNames(for family: String) -> [String] { NSFontManager.shared.availableMembers(ofFontFamily: family)?.compactMap { $0.first as? String } ?? [] }
#endif

struct FontDetailView: View {
    @Environment(\.colorScheme) private var systemScheme
    @State private var appeared = false

    let font: DemoFontFamily

    var body: some View {
        let color: Color = RDSColors.random(using: systemScheme)
        let labelColor: Color = RDSColorContrast.onColor(for: color, scheme: systemScheme)
        
        ZStack(alignment: .topLeading) {
            color.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 8) {
                Text("Large Title").reeceText(.h1B, family: font.family)
                Spacer()
                Text("Title").reeceText(.h2M, family: font.family)
                Text("Title 2").reeceText(.h3M, family: font.family)
                Text("Title 3").reeceText(.h4R, family: font.family)
                Spacer()
                Text("Headline").reeceText(.h5B, family: font.family)
                Text("Subheadline").reeceText(.h5R, family: font.family)
                Spacer()
                Text("Body").reeceText(.body, family: font.family)
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.").reeceText(.body, family: font.family)
                let families = ds_availableFontFamilies()
                if let family = families.first(where: { $0.localizedCaseInsensitiveContains(font.displayName) }) {
                    let names = ds_fontNames(for: family)
                    if !names.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(font.family) faces available:")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            ForEach(names, id: \ .self) { name in
                                Text(name)
                                    .font(.custom(name, size: 16))
                            }
                        }
                    }
                }
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
