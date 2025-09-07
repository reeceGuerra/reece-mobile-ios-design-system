//
//  PrimaryView.swift
//  RDSDesignSystemDemo
//
//  Created by Carlos Lopez on 30/08/25.
//
import SwiftUI
import RDSUI

struct PrimaryView: View {
    @Environment(\.rdsTheme) private var themeMode: Binding<RDSThemeMode>
    @Environment(\.colorScheme) private var systemScheme
    let onSelect: (PaletteTone) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ColorPaletteCard(
                    title: "Dark Blue",
                    tones: RDSColors.primary.DarkBlue.Tone.allCases.map { tone in
                        let c = RDSColors.primary.DarkBlue.color(tone, using: systemScheme)
                        let hex = RDSColorExport.hex(from: c) ?? "#N/A"
                        return PaletteTone(hex, name: "DarkBlue Tone \(tone.rawValue)")
                    },
                    maxBands: RDSColors.primary.DarkBlue.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Light Blue",
                    tones: RDSColors.primary.LightBlue.Tone.allCases.map { tone in
                        let c = RDSColors.primary.LightBlue.color(tone, using: systemScheme)
                        let hex = RDSColorExport.hex(from: c) ?? "#N/A"
                        return PaletteTone(hex, name: "LightBlue Tone \(tone.rawValue)")
                    },
                    maxBands: RDSColors.primary.LightBlue.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Dark Text Gray",
                    tones: RDSColors.primary.DarkTextGray.Tone.allCases.map { tone in
                        let c = RDSColors.primary.DarkTextGray.color(tone, using: systemScheme)
                        let hex = RDSColorExport.hex(from: c) ?? "#N/A"
                        return PaletteTone(hex, name: "Dark Text Gray Tone \(tone.rawValue)")
                    },
                    maxBands: RDSColors.primary.DarkTextGray.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
            }
            .padding()
        }
        .applyThemedBackground()
        .rdsNavigationBar(title: "Colors - Primary", trailing: {
            RDSThemeMenuView()
        })
    }
}
