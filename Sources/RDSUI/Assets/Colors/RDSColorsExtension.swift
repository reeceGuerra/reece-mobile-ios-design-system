//
//  RDSColors+Random.swift
//  RDSDesignSystem
//
//  Utility to get a random color from any defined family/tone.
//

import SwiftUI

public extension RDSColors {
    /// Returns a random color from all Primary, Secondary and Support families.
    /// - Parameter scheme: Current color scheme (light/dark).
    @MainActor
    static func random(using scheme: ColorScheme) -> Color {
        // Construimos una lista de generadores (closures) que devuelven un Color
        var providers: [() -> Color] = []

        // MARK: - Primary families
        providers += Primary.DarkBlue.Tone.allCases.map { tone in
            { Primary.DarkBlue.color(tone, using: scheme) }
        }
        providers += Primary.LightBlue.Tone.allCases.map { tone in
            { Primary.LightBlue.color(tone, using: scheme) }
        }
        providers += Primary.DarkTextGray.Tone.allCases.map { tone in
            { Primary.DarkTextGray.color(tone, using: scheme) }
        }

        // MARK: - Secondary families (tones)
        providers += Secondary.Orange.Tone.allCases.map { tone in
            { Secondary.Orange.color(tone, using: scheme) }
        }
        providers += Secondary.TextGray.Tone.allCases.map { tone in
            { Secondary.TextGray.color(tone, using: scheme) }
        }
        providers += Secondary.MediumGrey.Tone.allCases.map { tone in
            { Secondary.MediumGrey.color(tone, using: scheme) }
        }
        providers += Secondary.LightGray.Tone.allCases.map { tone in
            { Secondary.LightGray.color(tone, using: scheme) }
        }

        // MARK: - Secondary single-tone
        providers.append { Secondary.White.color(using: scheme) }
        providers.append { Secondary.OffWhite.color(using: scheme) }
        providers.append { Secondary.Black.color(using: scheme) }

        // MARK: - Support families (tones)
        providers += Support.Green.Tone.allCases.map { tone in
            { Support.Green.color(tone, using: scheme) }
        }
        providers += Support.OrangyRed.Tone.allCases.map { tone in
            { Support.OrangyRed.color(tone, using: scheme) }
        }
        providers += Support.Yellow.Tone.allCases.map { tone in
            { Support.Yellow.color(tone, using: scheme) }
        }
        providers += Support.Teal.Tone.allCases.map { tone in
            { Support.Teal.color(tone, using: scheme) }
        }
        providers += Support.SkyBlue.Tone.allCases.map { tone in
            { Support.SkyBlue.color(tone, using: scheme) }
        }
        providers += Support.Purple.Tone.allCases.map { tone in
            { Support.Purple.color(tone, using: scheme) }
        }

        // MARK: - Support single-tone
        providers.append { Support.HoverBlue.color(using: scheme) }

        // Defensive: si no hubiera providers
        guard !providers.isEmpty else { return .clear }

        // Selecciona aleatoriamente
        let randomIndex = Int.random(in: 0 ..< providers.count)
        return providers[randomIndex]()
    }
}
