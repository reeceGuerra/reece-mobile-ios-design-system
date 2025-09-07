//
//  SecondaryView.swift
//  RDSDesignSystemDemo
//
//  Created by Carlos Lopez on 31/08/25.
//

import SwiftUI
import RDSUI

struct SecondaryView: View {
    @Environment(\.rdsTheme) private var themeMode: Binding<RDSThemeMode>
    @Environment(\.colorScheme) private var systemScheme
    let onSelect: (PaletteTone) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ColorPaletteCard(
                    title: "Orange",
                    tones: RDSColors.secondary.Orange.Tone.allCases.map { tone in
                        let c = RDSColors.secondary.Orange.color(tone, using: systemScheme)
                        let hex = RDSColorExport.hex(from: c) ?? "#N/A"
                        return PaletteTone(hex, name: "Orange Tone \(tone.rawValue)")
                    },
                    maxBands: RDSColors.secondary.Orange.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Text Gray",
                    tones: RDSColors.secondary.TextGray.Tone.allCases.map { tone in
                        let c = RDSColors.secondary.TextGray.color(tone, using: systemScheme)
                        let hex = RDSColorExport.hex(from: c) ?? "#N/A"
                        return PaletteTone(hex, name: "TextGray Tone \(tone.rawValue)")
                    },
                    maxBands: RDSColors.secondary.TextGray.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Medium Gray",
                    tones: RDSColors.secondary.MediumGrey.Tone.allCases.map { tone in
                        let c = RDSColors.secondary.MediumGrey.color(tone, using: systemScheme)
                        let hex = RDSColorExport.hex(from: c) ?? "#N/A"
                        return PaletteTone(hex, name: "Medium Gray Tone \(tone.rawValue)")
                    },
                    maxBands: RDSColors.secondary.MediumGrey.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Light Gray",
                    tones: RDSColors.secondary.LightGray.Tone.allCases.map { tone in
                        let c = RDSColors.secondary.LightGray.color(tone, using: systemScheme)
                        let hex = RDSColorExport.hex(from: c) ?? "#N/A"
                        return PaletteTone(hex, name: "Light Gray Tone \(tone.rawValue)")
                    },
                    maxBands: RDSColors.secondary.LightGray.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "White",
                    tones: [.init(RDSColorExport.hex(from: RDSColors.secondary.White.color(using: systemScheme)) ?? "#N/A", name: "White")],
                    maxBands: 1,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "OffWhite",
                    tones: [.init(RDSColorExport.hex(from: RDSColors.secondary.OffWhite.color(using: systemScheme)) ?? "#N/A", name: "OffWhite")],
                    maxBands: 1,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Black",
                    tones: [.init(RDSColorExport.hex(from: RDSColors.secondary.Black.color(using: systemScheme)) ?? "#N/A", name: "Black")],
                    maxBands: 1,
                ) { tapped in
                    onSelect(tapped)
                }
            }
            .padding()
        }
        .applyThemedBackground()
        .rdsNavigationBar(title: "Colors - Secondary", trailing: {
            RDSThemeMenuView()
        })
    }
}
