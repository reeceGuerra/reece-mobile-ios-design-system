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
            VStack(alignment: .leading, spacing: 16) {
                Text("Dark Blue").font(.headline)
                ColorRowView(tones: DarkBlueTone.allCases) { tone in
                    ReeceColors.primary.darkBlue(tone, using: systemScheme)
                }

                Text("Light Blue").font(.headline)
                ColorRowView(tones: LightBlueTone.allCases) { tone in
                    ReeceColors.primary.lightBlue(tone, using: systemScheme)
                }

                Text("Dark Text Gray").font(.headline)
                ColorRowView(tones: DarkTextGrayTone.allCases) { tone in
                    ReeceColors.primary.darkTextGray(tone, using: systemScheme)
                }
            }
            .padding()
        }
        .applyThemedBackground()
        .reeceToolbar(title: "Primary")
    }
}

struct ColorRowView<T: CaseIterable & RawRepresentable>: View where T.RawValue == Int {
    let tones: [T]
    let colorForTone: (T) -> Color

    var body: some View {
        HStack(spacing: 8) {
            ForEach(tones, id: \.rawValue) { tone in
                RoundedRectangle(cornerRadius: 8)
                    .fill(colorForTone(tone))
                    .frame(width: 30, height: 30)
                    .overlay(Text("\(tone.rawValue)").font(.caption2).foregroundColor(.white))
            }
        }
    }
}
