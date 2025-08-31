//
//  HomeView.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 30/08/25.
//

import SwiftUI
import ReeceDesignSystem

// Asegúrate de tener estos tipos en tu proyecto:
// enum ReeceRoute: Hashable { case primary, colorDetail(name: String, hex: String) }
// final class NavRouter: ObservableObject { @Published var path = NavigationPath(); func push(_ r: ReeceRoute){ path.append(r) }; func pop(){ if !path.isEmpty { path.removeLast() } } }

struct HomeView: View {
    @Environment(\.colorScheme) private var systemScheme
    @StateObject private var vm = HomeViewModel()
    @StateObject private var router = NavRouter() // ← ruta compartida
    @State private var toolbarTitle: String = "Reece DS"
    @State private var toolbarShowBack: Bool = false
    
    var body: some View {
        // Derivados de theme (como los tenías)
        let effective: ColorScheme = vm.effectiveScheme(using: systemScheme)
        let background: Color     = vm.backgroundColor(using: systemScheme)
        let cellBg: Color         = vm.cellBackgroundColor(using: systemScheme)
        let textColor: Color      = vm.primaryTextColor(using: systemScheme)
        let tintColor: Color      = vm.accentColor(using: systemScheme)
        
        NavigationStack(path: $router.path) {
            List {
                Section("FAMILIES") {
                    // Navegación declarativa por valor
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
            // Destinos centralizados por ruta
            .navigationDestination(for: ReeceRoute.self) { route in
                switch route {
                case .primary:
                    PrimaryView(
                        mode: $vm.themeMode,
                        systemScheme: systemScheme
                    ) { tapped in
                        // Empuja detalle con nombre + hex
                        router.push(.colorDetail(name: tapped.name, hex: tapped.hex))
                    }
                    .environmentObject(vm)
                    .onAppear {
                        toolbarTitle   = "Primary"
                        toolbarShowBack = true
                    }
                    
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
                        toolbarTitle   = "Secondary"
                        toolbarShowBack = true
                    }
                case .support:
                    SupportView(mode: $vm.themeMode, systemScheme: systemScheme) { tapped in
                        router.push(.colorDetail(name: tapped.name, hex: tapped.hex))
                    }
                    .environmentObject(vm)
                    .onAppear() {
                        toolbarTitle   = "Support"
                        toolbarShowBack = true
                    }
                case let .colorDetail(name, hex):
                    ColorDetailView(
                        title: name,
                        color: Color(hex: hex) // respeta scheme si es dinámico
                    )
                    .environmentObject(vm)
                    .onAppear {
                        toolbarTitle   = "dffdf"
                        toolbarShowBack = true
                    }
                }
            }
        }
        .reeceToolbar(title: toolbarTitle,
                      showBack: toolbarShowBack,
                      backBehavior: .pop)
        .environmentObject(vm)
        .environmentObject(router)
        .preferredColorScheme(effective)
        .toolbarBackground(background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(effective, for: .navigationBar)
        .onAppear {
            vm.applyThemeSideEffects()
            toolbarTitle = "Reece DS"
            toolbarShowBack = false
        }
        .onChange(of: vm.themeMode) { vm.applyThemeSideEffects() }
        .reeceBackground(background)
        .reeceCellBackground(cellBg)
    }
}

#Preview { HomeView() }
