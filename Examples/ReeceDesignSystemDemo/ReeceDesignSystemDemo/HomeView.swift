//
//  ContentView.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 30/08/25.
//

import SwiftUI
import ReeceDesignSystem

struct HomeView: View {
    @Environment(\.colorScheme) private var systemScheme
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        let effective: ColorScheme =  vm.effectiveScheme(using: systemScheme)
        let background: Color = vm.backgroundColor(using: systemScheme)
        let cellBg: Color = vm.cellBackgroundColor(using: systemScheme)
        let textColor: Color  = vm.primaryTextColor(using: systemScheme)
        let tintColor: Color  = vm.accentColor(using: systemScheme)
        let menuBg: Color = vm.menuLabelBackground(using: systemScheme)
        let menuBorder: Color = vm.menuLabelBorder(using: systemScheme)
        let menuIcon: String = vm.imageThemeSystem(using: systemScheme)
        
        
        NavigationStack {
            List {
                Section("FAMILIES") {
                    NavigationLink("Primary") {
                        PrimaryView(mode: $vm.themeMode, systemScheme: systemScheme)
                    }
                }
                .listRowBackground(cellBg)
            }
            .listStyle(.insetGrouped)
            .foregroundStyle(textColor)
            .tint(tintColor)
            .reeceToolbar(title: "Reece DS")
            .scrollContentBackground(.hidden)
            .background(background)
        }
        .environment(vm)
        .preferredColorScheme(effective)
        .toolbarBackground(background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(effective, for: .navigationBar)
        .onAppear { vm.applyThemeSideEffects() }
        .onChange(of: vm.themeMode) {
            vm.applyThemeSideEffects()
        }
        .reeceBackground(background)
        .reeceCellBackground(cellBg)
    }
}

#Preview { HomeView() }
