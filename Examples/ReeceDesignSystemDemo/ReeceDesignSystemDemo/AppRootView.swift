//
//  AppRootView.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 31/08/25.
//
import SwiftUI
import RDSUI

struct AppRootView: View {
    @Environment(\.colorScheme) private var systemScheme
    @StateObject private var router = ReeceNavRouter()
    @State private var themeMode: ReeceThemeMode = .system

    var body: some View {
        let background = ReeceThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode) == .dark
        ? Color(white: 0.30)
        : Color(white: 0.90)
        let cellBg = ReeceThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode) == .dark
        ? Color(white: 0.50)
        : Color.white
        let textColor = ReeceThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode) == .dark
        ? Color.white.opacity(0.92)
        : Color.black.opacity(0.9)
        let tintColor = ReeceThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode) == .dark
        ? Color.white.opacity(0.95)
        : Color.black.opacity(0.95)
        
        NavigationStack(path: $router.path) {
            ZStack {
                List {
                    Section("Assets") {
                        NavigationLink("Colors", value: ReeceRoute.home)
                        NavigationLink("Fonts", value: ReeceRoute.fontsview)
                    }
                    .listRowBackground(cellBg)
                }
                .listStyle(.insetGrouped)
                .foregroundStyle(textColor)
                .tint(tintColor)
                .scrollContentBackground(.hidden)
                .background(background)
                .reeceBackground(background)
                .reeceCellBackground(cellBg)
                .reeceText(.body)
            }
            .reeceNavigationBar(
                title: "Reece DS",
                showBack: false, trailing:  {
                    ReeceThemeMenuView()
            })
                .navigationDestination(for: ReeceRoute.self) { route in
                    switch route {
                    case .home:
                        ColorsView()
                    case .primary:
                        PrimaryView() { tapped in
                            router.push(.colorDetail(name: tapped.name, hex: tapped.hex))
                        }
                    case .secondary:
                        SecondaryView() { tapped in
                            router.push(.colorDetail(name: tapped.name, hex: tapped.hex))
                        }
                    case .support:
                        SupportView() { tapped in
                            router.push(.colorDetail(name: tapped.name, hex: tapped.hex))
                        }
                    case let .colorDetail(name, hex):
                        ColorDetailView(
                            title: name,
                            color: Color(hex: hex)
                        )
                    case .fontsview:
                        FontsView { font in
                            router.push(.fontDetail(font: font))
                        }
                    case let .fontDetail(font):
                        FontDetailView(font: font)
                    }
                }
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbarVisibility(.hidden, for: .navigationBar)
        .preferredColorScheme(themeMode.preferredOverride)
        .environmentObject(router)
        .environment(\.reeceTheme, $themeMode)
    }
}

#Preview {
    AppRootView()
}
