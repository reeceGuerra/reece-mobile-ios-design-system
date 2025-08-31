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
                        return PaletteTone(hex) // tu struct de la card
                    },
                ) { tapped in
                    print("Tapped Dark Blue tone:", tapped.hex)
                }

                // Light Blue y Dark Text Gray igual, solo cambias el enum
                // ColorPaletteCard(title: "Light Blue", tones: LightBlueTone.allCases.map { ... }) { ... }
                // ColorPaletteCard(title: "Dark Text Gray", tones: DarkTextGrayTone.allCases.map { ... }) { ... }
            }
            .padding()
        }
        .applyThemedBackground()
        .reeceToolbar(title: "Primary", showBack: true)
    }
}

