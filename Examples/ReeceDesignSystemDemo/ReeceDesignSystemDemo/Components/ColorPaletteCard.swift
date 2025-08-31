//
//  ColorPaletteCard.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 31/08/25.
//

import SwiftUI
import ReeceDesignSystem // para Color(hex:)

/// Modelo simple de un tono a renderizar en la card.
public struct PaletteTone: Identifiable, Sendable {
    public let id = UUID()
    public let hex: String

    public init(_ hex: String) { self.hex = hex }

    /// Color SwiftUI derivado del HEX (usa tu extensión `Color(hex:)` del package).
    public var color: Color { Color(hex: hex) }

    /// Texto blanco/negro según luminancia percibida (regla simple y performante).
    public var labelColor: Color {
        // Extrae RGB [0,1] desde el HEX de 6 u 8 dígitos (#RRGGBB[AA])
        var r: Double = 0, g: Double = 0, b: Double = 0
        let c = color.resolve(in: .init()) // Color -> UIColor-like for current env
        #if canImport(UIKit)
        if let ui = UIColor(cgColor: c.cgColor) as UIColor? {
            var rr: CGFloat = 0, gg: CGFloat = 0, bb: CGFloat = 0, aa: CGFloat = 0
            ui.getRed(&rr, green: &gg, blue: &bb, alpha: &aa)
            r = Double(rr); g = Double(gg); b = Double(bb)
        }
        #endif
        // Luminancia sRGB aproximada
        let luminance = 0.2126*r + 0.7152*g + 0.0722*b
        return luminance > 0.57 ? .black : .white
    }
}

/// Card que muestra un título y una pila de bandas con los tonos.
/// - Las bandas se redondean arriba/abajo para parecer una paleta compacta.
/// - Cada banda muestra el HEX centrado y dispara `onTapTone` al tocarla.
public struct ColorPaletteCard: View {
    @Environment(\.colorScheme) private var systemScheme
    public let title: String
    public let tones: [PaletteTone]
    public var maxBands: Int = 4           // cuántas bandas mostrar (ej. 4 como en el mock)
    public var bandHeight: CGFloat = 34
    public var onTapTone: (PaletteTone) -> Void

    public init(
        title: String,
        tones: [PaletteTone],
        maxBands: Int = 4,
        bandHeight: CGFloat = 34,
        onTapTone: @escaping (PaletteTone) -> Void
    ) {
        self.title = title
        self.tones = tones
        self.maxBands = maxBands
        self.bandHeight = bandHeight
        self.onTapTone = onTapTone
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)

            // Paleta apilada
            VStack(spacing: 0) {
                let show = Array(tones.prefix(maxBands)) // top→bottom en el orden recibido
                ForEach(Array(show.enumerated()), id: \.element.id) { idx, tone in
                    ZStack {
                        tone.color
                        Text(ReeceColorExport.hexString(for: tone.color, scheme: systemScheme, includeAlpha: false) ?? tone.hex.uppercased())
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(tone.labelColor)
                            .shadow(radius: 0.5)
                    }
                    .frame(height: bandHeight)
                    .contentShape(Rectangle())
                    .onTapGesture { onTapTone(tone) }
                    .clipShape(RoundedCorners(
                        radius: 14,
                        corners: corners(for: idx, count: show.count)
                    ))
                    .overlay(
                        RoundedCorners(
                            radius: 14,
                            corners: corners(for: idx, count: show.count)
                        )
                        .stroke(.black.opacity(0.06), lineWidth: 0.5)
                    )
                }
            }
            .background(
                // Sombra suave alrededor del conjunto
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.clear)
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
            )
        }
        .padding(16)
        .background(
            // Card contenedora suave
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white.opacity(0.92))
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)
        )
    }

    // MARK: - Helpers

    private func corners(for idx: Int, count: Int) -> UIRectCorner {
        switch (idx, count) {
        case (0, 1): return [.allCorners]
        case (0, _): return [.topLeft, .topRight]
        case (count-1, _): return [.bottomLeft, .bottomRight]
        default: return []
        }
    }
}

/// Shape para redondear sólo algunos bordes (arriba/abajo).
fileprivate struct RoundedCorners: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
