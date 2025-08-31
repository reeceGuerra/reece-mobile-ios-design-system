//
//  SupportView.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 31/08/25.
//

import SwiftUI
import ReeceDesignSystem

struct SupportView: View {
    @Binding var mode: ReeceThemeMode
    let systemScheme: ColorScheme
    let onSelect: (PaletteTone) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ColorPaletteCard(
                    title: "Green",
                    tones: GreenTone.allCases.map { tone in
                        let c = ReeceColors.support.green(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "Green Tone \(tone.rawValue)")
                    },
                    maxBands: GreenTone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "OrangyRed",
                    tones: OrangyRedTone.allCases.map { tone in
                        let c = ReeceColors.support.orangyRed(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "OrangyRed Tone \(tone.rawValue)")
                    },
                    maxBands: OrangyRedTone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Yellow",
                    tones: YellowTone.allCases.map { tone in
                        let c = ReeceColors.support.yellow(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "Yellow Tone \(tone.rawValue)")
                    },
                    maxBands: YellowTone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Teal",
                    tones: TealTone.allCases.map { tone in
                        let c = ReeceColors.support.teal(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "Teal Tone \(tone.rawValue)")
                    },
                    maxBands: TealTone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "SkyBlue",
                    tones: SkyBlueTone.allCases.map { tone in
                        let c = ReeceColors.support.skyBlue(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "SkyBlue Tone \(tone.rawValue)")
                    },
                    maxBands: SkyBlueTone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Purple",
                    tones: PurpleTone.allCases.map { tone in
                        let c = ReeceColors.support.purple(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "Purple Tone \(tone.rawValue)")
                    },
                    maxBands: PurpleTone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "HoverBlue",
                    tones: [.init(ReeceColorExport.hexString(for: ReeceColors.support.hoverBlue(using: systemScheme)) ?? "#N/A", name: "HoverBlue")],
                    maxBands: 1,
                ) { tapped in
                    onSelect(tapped)
                }
            }
            .padding()
        }
        .applyThemedBackground()
    }
}
