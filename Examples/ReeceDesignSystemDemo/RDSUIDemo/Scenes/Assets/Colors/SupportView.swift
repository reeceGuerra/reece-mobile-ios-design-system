//
//  SupportView.swift
//  RDSDesignSystemDemo
//
//  Created by Carlos Lopez on 31/08/25.
//

import SwiftUI
import RDSUI

struct SupportView: View {
    @Environment(\.rdsTheme) private var themeMode: Binding<RDSThemeMode>
    @Environment(\.colorScheme) private var systemScheme
    let onSelect: (PaletteTone) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ColorPaletteCard(
                    title: "Green",
                    tones: RDSColors.support.Green.Tone.allCases.map { tone in
                        let c = RDSColors.support.Green.color(tone, using: systemScheme)
                        let hex = RDSColorExport.hex(from: c) ?? "#N/A"
                        return PaletteTone(hex, name: "Green Tone \(tone.rawValue)")
                    },
                    maxBands: RDSColors.support.Green.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "OrangyRed",
                    tones: RDSColors.support.OrangyRed.Tone.allCases.map { tone in
                        let c = RDSColors.support.OrangyRed.color(tone, using: systemScheme)
                        let hex = RDSColorExport.hex(from: c) ?? "#N/A"
                        return PaletteTone(hex, name: "OrangyRed Tone \(tone.rawValue)")
                    },
                    maxBands: RDSColors.support.OrangyRed.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Yellow",
                    tones: RDSColors.support.Yellow.Tone.allCases.map { tone in
                        let c = RDSColors.support.Yellow.color(tone, using: systemScheme)
                        let hex = RDSColorExport.hex(from: c) ?? "#N/A"
                        return PaletteTone(hex, name: "Yellow Tone \(tone.rawValue)")
                    },
                    maxBands: RDSColors.support.Yellow.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Teal",
                    tones: RDSColors.support.Teal.Tone.allCases.map { tone in
                        let c = RDSColors.support.Teal.color(tone, using: systemScheme)
                        let hex = RDSColorExport.hex(from: c) ?? "#N/A"
                        return PaletteTone(hex, name: "Teal Tone \(tone.rawValue)")
                    },
                    maxBands: RDSColors.support.Teal.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "SkyBlue",
                    tones: RDSColors.support.SkyBlue.Tone.allCases.map { tone in
                        let c = RDSColors.support.SkyBlue.color(tone, using: systemScheme)
                        let hex = RDSColorExport.hex(from: c) ?? "#N/A"
                        return PaletteTone(hex, name: "SkyBlue Tone \(tone.rawValue)")
                    },
                    maxBands: RDSColors.support.SkyBlue.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Purple",
                    tones: RDSColors.support.Purple.Tone.allCases.map { tone in
                        let c = RDSColors.support.Purple.color(tone, using: systemScheme)
                        let hex = RDSColorExport.hex(from: c) ?? "#N/A"
                        return PaletteTone(hex, name: "Purple Tone \(tone.rawValue)")
                    },
                    maxBands: RDSColors.support.Purple.Tone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "HoverBlue",
                    tones: [.init(RDSColorExport.hex(from: RDSColors.support.HoverBlue.color(using: systemScheme)) ?? "#N/A", name: "HoverBlue")],
                    maxBands: 1,
                ) { tapped in
                    onSelect(tapped)
                }
            }
            .padding()
        }
        .applyThemedBackground()
        .rdsNavigationBar(title: "Colors - Support", trailing: {
            RDSThemeMenuView()
        })
    }
}
