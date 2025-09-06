//
//  AppRootView.swift
//  RDSDesignSystemDemo
//
//  Created by Carlos Lopez on 31/08/25.
//
import SwiftUI
import RDSUI

struct AppRootView: View {
    @Environment(\.colorScheme) private var systemScheme
    @StateObject private var router = RDSNavRouter()
    @State private var themeMode: RDSThemeMode = .system

    var body: some View {
        let background = themeMode.resolve(systemScheme) == .dark
        ? Color(white: 0.30)
        : Color(white: 0.90)
        let cellBg = themeMode.resolve(systemScheme) == .dark
        ? Color(white: 0.50)
        : Color.white
        let textColor = themeMode.resolve(systemScheme) == .dark
        ? Color.white.opacity(0.92)
        : Color.black.opacity(0.9)
        let tintColor = themeMode.resolve(systemScheme) == .dark
        ? Color.white.opacity(0.95)
        : Color.black.opacity(0.95)
        
        NavigationStack(path: $router.path) {
            ZStack {
                List {
                    Section("Assets") {
                        NavigationLink("Colors", value: RDSRoute.home)
                        NavigationLink("Fonts", value: RDSRoute.fontsview)
                    }
                    .listRowBackground(cellBg)
                }
                .listStyle(.insetGrouped)
                .foregroundStyle(textColor)
                .tint(tintColor)
                .scrollContentBackground(.hidden)
                .background(background)
                .rdsBackground(background)
                .rdsCellBackground(cellBg)
                .rdsTextStyle(.body)
            }
            .rdsNavigationBar(
                title: "Reece DS",
                showBack: false, trailing:  {
                    RDSThemeMenuView()
            })
                .navigationDestination(for: RDSRoute.self) { route in
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
                            color: Color.rds(hex)
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
        .environment(\.rdsTheme, $themeMode)
    }
}

#Preview {
    AppRootView()
}
