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
    @State private var topBarColor: Color? = nil
    
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
            .padding(.top, 55)
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
                    .onAppear {
                        topTitle = "Primary"
                        topBarColor = nil
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
                        topTitle = "Secondary"
                        topBarColor = nil
                    }
                    
                case .support:
                    SupportView(mode: $vm.themeMode, systemScheme: systemScheme) { tapped in
                        router.push(.colorDetail(name: tapped.name, hex: tapped.hex))
                    }
                    .environmentObject(vm)
                    .onAppear() {
                        topTitle = "Support"
                        topBarColor = nil
                    }
                    
                case let .colorDetail(name, hex):
                    ColorDetailView(
                        title: name,
                        color: Color(hex: hex)
                    )
                    .environmentObject(vm)
                    .onAppear {
                        topTitle = ""
                        topBarColor = Color(hex: hex)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .top) {
            ReeceTopBar(title: topTitle, overrideBackground: topBarColor)
                .environmentObject(vm)
                .environmentObject(router)
        }
        .environmentObject(vm)
        .environmentObject(router)
        .preferredColorScheme(effective)
        .onAppear {
            vm.applyThemeSideEffects()
            topTitle = "Reece DS"
            topBarColor = nil
        }
        .onChange(of: vm.themeMode) { vm.applyThemeSideEffects() }
        .reeceBackground(background)
        .reeceCellBackground(cellBg)
    }
}

#Preview { HomeView() }
