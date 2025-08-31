//
//  AppRootView.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 31/08/25.
//
import SwiftUI
import ReeceDesignSystem

struct AppRootView: View {
    @Environment(\.colorScheme) private var systemScheme
    @StateObject private var router = ReeceNavRouter()
    @State private var themeMode: ReeceThemeMode = .system

    var body: some View {
        let effective = ReeceThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode)
        NavigationStack(path: $router.path) {
            HomeView()
                .navigationDestination(for: ReeceRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView()
                    case .primary:
                        PrimaryView() { tapped in
                            router.push(.colorDetail(name: tapped.name, hex: tapped.hex))
                        }.reeceNavigationBar(title: "Primary Family", trailing: {
                            MenuView()
                        })
                    case .secondary:
                        SecondaryView() { tapped in
                            router.push(.colorDetail(name: tapped.name, hex: tapped.hex))
                        }
                        .reeceNavigationBar(title: "Secondary Family", trailing: {
                            MenuView()
                        })
                    case .support:
                        SupportView() { tapped in
                            router.push(.colorDetail(name: tapped.name, hex: tapped.hex))
                        }
                        .reeceNavigationBar(title: "Support Familty", trailing: {
                            MenuView()
                        })
                    case let .colorDetail(name, hex):
                        ColorDetailView(
                            title: name,
                            color: Color(hex: hex)
                        ).reeceNavigationBar(title: "", overrideBackground: Color(hex: hex), trailing: {
                            MenuView()
                        })
                    }
                }
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbarVisibility(.hidden, for: .navigationBar)
        .preferredColorScheme(effective)
        .environmentObject(router)
        .environment(\.reeceTheme, $themeMode)
    }
}
