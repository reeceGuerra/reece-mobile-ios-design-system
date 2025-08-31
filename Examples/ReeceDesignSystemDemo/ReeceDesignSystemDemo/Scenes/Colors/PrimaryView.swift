import SwiftUI
import ReeceDesignSystem

struct PrimaryView: View {
    @Binding var mode: ReeceThemeMode
    let systemScheme: ColorScheme

    // TODO: reemplaza por tus arrays reales de Figma
    private let darkBlueHEX = ["#EDF3F6", "#D8E2EB", "#C5D3E1", "#B0C2D6",
                               "#9BB1CB", "#869FBE", "#6E8AAE", "#576E94",
                               "#3E5479", "#2A3D5D"] // 10 → 100 (ejemplo)

    private var darkBlueTones: [PaletteTone] {
        darkBlueHEX.reversed().map(PaletteTone.init) // ↑ oscuro abajo
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ColorPaletteCard(
                    title: "Dark Blue",
                    tones: darkBlueTones,
                    maxBands: 10,                      // muestra 4 bandas
                    bandHeight: 36
                ) { tapped in
                    // Navegación futura: por ahora sólo log
                    print("Tapped tone:", tapped.hex)
                }

                // Repite una card para Light Blue y Dark Text Gray (pasando sus HEX)
                // ColorPaletteCard(title: "Light Blue", tones: lightBlueTones) { ... }
                // ColorPaletteCard(title: "Dark Text Gray", tones: grayTones) { ... }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .applyThemedBackground()                // fondo heredado del Home
        .reeceToolbar(title: "Primary", showBack: true)
    }
}
