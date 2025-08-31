//
//  HomeView.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 30/08/25.
//
import SwiftUI
import ReeceDesignSystem

struct HomeView: View {
    @Environment(\.colorScheme) private var systemScheme
    @StateObject private var vm = HomeViewModel()
    @StateObject private var router = NavRouter()

    // Estado central del título del top bar
    @State private var topTitle: String = "Reece DS"

    var body: some View {
        let effective = vm.effectiveScheme(using: systemScheme)
        let background = vm.backgroundColor(using: systemScheme)
        let cellBg = vm.cellBackgroundColor(using: systemScheme)
        let textColor = vm.primaryTextColor(using: systemScheme)
        let tintColor = vm.accentColor(using: systemScheme)

        NavigationStack(path: $router.path) {
            List {
                Section("FAMILIES") {
                    NavigationLink("Primary", value: ReeceRoute.primary)
                    NavigationLink("Secondary", value: ReeceRoute.secondary)
                    NavigationLink("Support", value: ReeceRoute.support)
                }
                .listRowBackground(cellBg)
            }
            .listStyle(.insetGrouped)
            .foregroundStyle(textColor)
            .tint(tintColor)
            .scrollContentBackground(.hidden)
            .background(background)
            
            .navigationDestination(for: ReeceRoute.self) { route in
                switch route {
                case .primary:
                    PrimaryView(
                        mode: $vm.themeMode,
                        systemScheme: systemScheme
                    ) { tapped in
                        router.push(.colorDetail(name: tapped.name, hex: tapped.hex))
                    }
                    .environmentObject(vm)
                    .onAppear { topTitle = "Primary" }
                    
                case .secondary:
                    
                    SecondaryView(
                        mode: $vm.themeMode,
                        systemScheme: systemScheme
                    ) { tapped in
                        // Empuja detalle con nombre + hex
                        router.push(.colorDetail(name: tapped.name, hex: tapped.hex))
                    }
                    .environmentObject(vm)
                    .onAppear {
                        topTitle = "Secondary"
                    }
                    
                case .support:
                    SupportView(mode: $vm.themeMode, systemScheme: systemScheme) { tapped in
                        router.push(.colorDetail(name: tapped.name, hex: tapped.hex))
                    }
                    .environmentObject(vm)
                    .onAppear() {
                        topTitle = "Support"
                    }

                case let .colorDetail(name, hex):
                    ColorDetailView(
                        title: name,
                        color: Color(hex: hex)
                    )
                    .environmentObject(vm)
                    .onAppear { topTitle = "Primary" } // o name si prefieres
                }
            }
        }
        // Ocultar barra nativa del sistema
        .toolbar(.hidden, for: .navigationBar)

        // Insertar nuestro top bar SIEMPRE arriba
        .safeAreaInset(edge: .top) {
            ReeceTopBar(title: topTitle)
                .environmentObject(vm)
                .environmentObject(router)
        }

        // Theming global (restaura estado al volver al root)
        .environmentObject(vm)
        .environmentObject(router)
        .preferredColorScheme(effective)
        .onAppear {
            vm.applyThemeSideEffects()
            topTitle = "Reece DS"
        }
        .onChange(of: vm.themeMode) { vm.applyThemeSideEffects() }
        .reeceBackground(background)
        .reeceCellBackground(cellBg)
    }
}

#Preview { HomeView() }
