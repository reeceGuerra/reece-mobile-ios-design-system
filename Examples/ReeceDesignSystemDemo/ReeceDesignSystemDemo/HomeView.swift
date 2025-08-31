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
    
    private var effective: ColorScheme { vm.effectiveScheme(using: systemScheme) }
    private var background: Color { vm.backgroundColor(using: systemScheme) }
    private var cellBg: Color { vm.cellBackgroundColor(using: systemScheme) }
    private var textColor: Color  { vm.primaryTextColor(using: systemScheme) }
    private var tintColor: Color  { vm.accentColor(using: systemScheme) }
    private var menuBg: Color { vm.menuLabelBackground(using: systemScheme) }
    private var menuBorder: Color { vm.menuLabelBorder(using: systemScheme) }
    private var menuIcon: String { vm.imageThemeSystem(using: systemScheme) }

    var body: some View {
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Reece DS")
                        .font(.title)
                        .foregroundStyle(textColor)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        ForEach(ReeceThemeMode.allCases) { theme in
                            Button { vm.themeMode = theme } label: { Label(theme.title, systemImage: vm.themeMode == theme ? "checkmark" : "") }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: menuIcon)
                            Text(vm.themeMode.title).font(.callout.weight(.semibold))
                        }
                        .padding(.horizontal, 12).padding(.vertical, 8)
                        .foregroundStyle(textColor)
                        .background(menuBg)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(menuBorder, lineWidth: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(background)
        }
        .preferredColorScheme(effective)
        .toolbarBackground(background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(effective, for: .navigationBar)
        .onChange(of: vm.themeMode) {
            vm.applyThemeSideEffects()
        }
    }
}

#Preview { HomeView() }
