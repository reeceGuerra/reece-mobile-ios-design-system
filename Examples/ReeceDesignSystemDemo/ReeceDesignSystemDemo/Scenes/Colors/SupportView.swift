//
//  SupportView.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 31/08/25.
//

import SwiftUI
import ReeceDesignSystem

struct SupportView: View {
    @Environment(\.reeceTheme) private var themeMode: Binding<ReeceThemeMode>
    @Environment(\.colorScheme) private var systemScheme
    let onSelect: (PaletteTone) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ColorPaletteCard(
                    title: "Green",
                    tones: ReeceColors.support.Green.Tone.allCases.map { tone in
                        let c = ReeceColors.support.Green.color(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "Green Tone \(tone.rawValue)")
                    },
                    maxBands: ReeceColors.support.Green.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "OrangyRed",
                    tones: ReeceColors.support.OrangyRed.Tone.allCases.map { tone in
                        let c = ReeceColors.support.OrangyRed.color(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "OrangyRed Tone \(tone.rawValue)")
                    },
                    maxBands: ReeceColors.support.OrangyRed.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Yellow",
                    tones: ReeceColors.support.Yellow.Tone.allCases.map { tone in
                        let c = ReeceColors.support.Yellow.color(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "Yellow Tone \(tone.rawValue)")
                    },
                    maxBands: ReeceColors.support.Yellow.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Teal",
                    tones: ReeceColors.support.Teal.Tone.allCases.map { tone in
                        let c = ReeceColors.support.Teal.color(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "Teal Tone \(tone.rawValue)")
                    },
                    maxBands: ReeceColors.support.Teal.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "SkyBlue",
                    tones: ReeceColors.support.SkyBlue.Tone.allCases.map { tone in
                        let c = ReeceColors.support.SkyBlue.color(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "SkyBlue Tone \(tone.rawValue)")
                    },
                    maxBands: ReeceColors.support.SkyBlue.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Purple",
                    tones: ReeceColors.support.Purple.Tone.allCases.map { tone in
                        let c = ReeceColors.support.Purple.color(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "Purple Tone \(tone.rawValue)")
                    },
                    maxBands: ReeceColors.support.Purple.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "HoverBlue",
                    tones: [.init(ReeceColorExport.hexString(for: ReeceColors.support.HoverBlue.color(using: systemScheme)) ?? "#N/A", name: "HoverBlue")],
                    maxBands: 1,
                ) { tapped in
                    onSelect(tapped)
                }
            }
            .padding()
        }
        .applyThemedBackground()
        .reeceNavigationBar(title: "Support Familty", trailing: {
            ReeceThemeMenuView()
        })
    }
}
