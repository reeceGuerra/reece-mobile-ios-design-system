//
//  PrimaryView.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 30/08/25.
//
import SwiftUI
import ReeceDesignSystem

struct PrimaryView: View {
    @Binding var mode: ReeceThemeMode
    let systemScheme: ColorScheme

    @State private var selected: PaletteTone?    // ← para navegación

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ColorPaletteCard(
                        title: "Dark Blue",
                        tones: DarkBlueTone.allCases.map { tone in
                            let c = ReeceColors.primary.darkBlue(tone, using: systemScheme)
                            let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                            return PaletteTone(hex, name: "DarkBlue Tone \(tone.rawValue)")
                        },
                        maxBands: DarkBlueTone.allCases.count,
                    ) { tapped in
                        selected = tapped
                    }
                    
                    ColorPaletteCard(
                        title: "Light Blue",
                        tones: LightBlueTone.allCases.map { tone in
                            let c = ReeceColors.primary.lightBlue(tone, using: systemScheme)
                            let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                            return PaletteTone(hex, name: "LightBlue Tone \(tone.rawValue)")
                        },
                        maxBands: LightBlueTone.allCases.count,
                    ) { tapped in
                        selected = tapped
                    }
                    
                    ColorPaletteCard(
                        title: "Dark Text Gray",
                        tones: DarkTextGrayTone.allCases.map { tone in
                            let c = ReeceColors.primary.darkTextGray(tone, using: systemScheme)
                            let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                            return PaletteTone(hex, name: "Dark Text Gray Tone \(tone.rawValue)")
                        },
                        maxBands: DarkTextGrayTone.allCases.count,
                    ) { tapped in
                        selected = tapped
                    }
                }
                .padding()
            }
            .applyThemedBackground()
            .navigationDestination(item: $selected) { tapped in
                // Resolver Color desde el HEX del tono tocado
                let toneColor = Color(hex: tapped.hex)
                ColorDetailView(
                    title: tapped.name,
                    color: toneColor
                )
                .environmentObject(HomeViewModel()) // usa tu VM compartido si lo tienes aquí
            }
            .reeceToolbar(title: "Primary", showBack: true)
        }
    }
}
