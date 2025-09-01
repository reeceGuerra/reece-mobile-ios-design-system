//
//  SecondaryView.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 31/08/25.
//

import SwiftUI
import ReeceDesignSystem

struct SecondaryView: View {
    @Environment(\.reeceTheme) private var themeMode: Binding<ReeceThemeMode>
    @Environment(\.colorScheme) private var systemScheme
    let onSelect: (PaletteTone) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ColorPaletteCard(
                    title: "Orange",
                    tones: ReeceColors.secondary.Orange.Tone.allCases.map { tone in
                        let c = ReeceColors.secondary.Orange.color(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "Orange Tone \(tone.rawValue)")
                    },
                    maxBands: ReeceColors.secondary.Orange.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Text Gray",
                    tones: ReeceColors.secondary.TextGray.Tone.allCases.map { tone in
                        let c = ReeceColors.secondary.TextGray.color(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "TextGray Tone \(tone.rawValue)")
                    },
                    maxBands: ReeceColors.secondary.TextGray.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Medium Gray",
                    tones: ReeceColors.secondary.MediumGrey.Tone.allCases.map { tone in
                        let c = ReeceColors.secondary.MediumGrey.color(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "Medium Gray Tone \(tone.rawValue)")
                    },
                    maxBands: ReeceColors.secondary.MediumGrey.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Light Gray",
                    tones: ReeceColors.secondary.LightGray.Tone.allCases.map { tone in
                        let c = ReeceColors.secondary.LightGray.color(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "Light Gray Tone \(tone.rawValue)")
                    },
                    maxBands: ReeceColors.secondary.LightGray.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "White",
                    tones: [.init(ReeceColorExport.hexString(for: ReeceColors.secondary.White.color(using: systemScheme)) ?? "#N/A", name: "White")],
                    maxBands: 1,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "OffWhite",
                    tones: [.init(ReeceColorExport.hexString(for: ReeceColors.secondary.OffWhite.color(using: systemScheme)) ?? "#N/A", name: "OffWhite")],
                    maxBands: 1,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Black",
                    tones: [.init(ReeceColorExport.hexString(for: ReeceColors.secondary.Black.color(using: systemScheme)) ?? "#N/A", name: "Black")],
                    maxBands: 1,
                ) { tapped in
                    onSelect(tapped)
                }
            }
            .padding()
        }
        .applyThemedBackground()
        .reeceNavigationBar(title: "Secondary Family", trailing: {
            ReeceThemeMenuView()
        })
    }
}
