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
                    tones: OrangeTone.allCases.map { tone in
                        let c = ReeceColors.secondary.orange(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "Orange Tone \(tone.rawValue)")
                    },
                    maxBands: OrangeTone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Text Gray",
                    tones: SecondaryTextGrayTone.allCases.map { tone in
                        let c = ReeceColors.secondary.textGray(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "TextGray Tone \(tone.rawValue)")
                    },
                    maxBands: SecondaryTextGrayTone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Medium Gray",
                    tones: MediumGreyTone.allCases.map { tone in
                        let c = ReeceColors.secondary.mediumGrey(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "Medium Gray Tone \(tone.rawValue)")
                    },
                    maxBands: MediumGreyTone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Light Gray",
                    tones: LightGrayTone.allCases.map { tone in
                        let c = ReeceColors.secondary.lightGray(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex, name: "Light Gray Tone \(tone.rawValue)")
                    },
                    maxBands: LightGrayTone.allCases.count,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "White",
                    tones: [.init(ReeceColorExport.hexString(for: ReeceColors.secondary.white(using: systemScheme)) ?? "#N/A", name: "White")],
                    maxBands: 1,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "OffWhite",
                    tones: [.init(ReeceColorExport.hexString(for: ReeceColors.secondary.offWhite(using: systemScheme)) ?? "#N/A", name: "OffWhite")],
                    maxBands: 1,
                ) { tapped in
                    onSelect(tapped)
                }
                
                ColorPaletteCard(
                    title: "Black",
                    tones: [.init(ReeceColorExport.hexString(for: ReeceColors.secondary.black(using: systemScheme)) ?? "#N/A", name: "Black")],
                    maxBands: 1,
                ) { tapped in
                    onSelect(tapped)
                }
            }
            .padding()
        }
        .applyThemedBackground()
        .reeceNavigationBar(title: "Secondary Family", trailing: {
            MenuView()
        })
    }
}
