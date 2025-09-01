//
//  PrimaryView.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 30/08/25.
//
import SwiftUI
import ReeceDesignSystem

struct PrimaryView: View {
    @Environment(\.reeceTheme) private var themeMode: Binding<ReeceThemeMode>
    @Environment(\.colorScheme) private var systemScheme
    let onSelect: (PaletteTone) -> Void

    var body: some View {
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
                    onSelect(tapped)
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
                    onSelect(tapped)
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
