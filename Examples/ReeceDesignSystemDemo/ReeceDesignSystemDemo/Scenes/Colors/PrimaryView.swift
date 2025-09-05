//
//  PrimaryView.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 30/08/25.
//
import SwiftUI
import RDSUI

struct PrimaryView: View {
    @Environment(\.reeceTheme) private var themeMode: Binding<ReeceThemeMode>
    @Environment(\.colorScheme) private var systemScheme
    let onSelect: (PaletteTone) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ColorPaletteCard(
                    title: "Dark Blue",
                    tones: ReeceColors.primary.DarkBlue.Tone.allCases.map { tone in
                        let c = ReeceColors.primary.DarkBlue.color(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "DarkBlue Tone \(tone.rawValue)")
                    },
                    maxBands: ReeceColors.primary.DarkBlue.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Light Blue",
                    tones: ReeceColors.primary.LightBlue.Tone.allCases.map { tone in
                        let c = ReeceColors.primary.LightBlue.color(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "LightBlue Tone \(tone.rawValue)")
                    },
                    maxBands: ReeceColors.primary.LightBlue.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Dark Text Gray",
                    tones: ReeceColors.primary.DarkTextGray.Tone.allCases.map { tone in
                        let c = ReeceColors.primary.DarkTextGray.color(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "Dark Text Gray Tone \(tone.rawValue)")
                    },
                    maxBands: ReeceColors.primary.DarkTextGray.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
            }
            .padding()
        }
        .applyThemedBackground()
        .reeceNavigationBar(title: "Primary Family", trailing: {
            ReeceThemeMenuView()
        })
    }
}
