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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // Dark Blue como Card
                ColorPaletteCard(
                    title: "Dark Blue",
                    tones: DarkBlueTone.allCases.map { tone in
                        let c = ReeceColors.primary.darkBlue(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex)
                    },
                    maxBands: DarkBlueTone.allCases.count,
                ) { tapped in
                    print("Tapped Dark Blue tone:", tapped.hex)
                }
                
                ColorPaletteCard(
                    title: "Light Blue",
                    tones: LightBlueTone.allCases.map { tone in
                        let c = ReeceColors.primary.lightBlue(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex)
                    },
                    maxBands: LightBlueTone.allCases.count,
                ) { tapped in
                    print("Tapped Light Blue tone:", tapped.hex)
                }
                
                ColorPaletteCard(
                    title: "Dark Text Gray",
                    tones: DarkTextGrayTone.allCases.map { tone in
                        let c = ReeceColors.primary.darkTextGray(tone, using: systemScheme)
                        let hex = ReeceColorExport.hexString(for: c, scheme: systemScheme) ?? "#N/A"
                        return PaletteTone(hex)
                    },
                    maxBands: DarkTextGrayTone.allCases.count,
                ) { tapped in
                    print("Tapped Dark Text Gray tone:", tapped.hex)
                }
            }
            .padding()
        }
        .applyThemedBackground()
        .reeceToolbar(title: "Primary", showBack: true)
    }
}

