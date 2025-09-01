//
//  HomeView.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 30/08/25.
//
import SwiftUI
import ReeceDesignSystem

struct ColorsView: View {
    @Environment(\.colorScheme) private var systemScheme
    @Environment(\.reeceTheme) private var themeMode: Binding<ReeceThemeMode>
    @EnvironmentObject private var router: ReeceNavRouter
    @StateObject private var vm = ColorsViewModel()
    
    var body: some View {
        
        let background = vm.backgroundColor(using: systemScheme,
                                            andThemeMode: themeMode.wrappedValue)
        let cellBg = vm.cellBackgroundColor(using: systemScheme,
                                            andThemeMode: themeMode.wrappedValue)
        let textColor = vm.primaryTextColor(using: systemScheme,
                                            andThemeMode: themeMode.wrappedValue)
        let tintColor = vm.accentColor(using: systemScheme,
                                       andThemeMode: themeMode.wrappedValue)
        ZStack {
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
            .reeceBackground(background)
            .reeceCellBackground(cellBg)
        }
        .reeceNavigationBar(
            title: "Reece DS - Colors", trailing:  {
                ReeceThemeMenuView()
        })
    }
}

#Preview {
    ColorsView()
        .environmentObject(ReeceNavRouter())
        .environment(\.reeceTheme, .constant(.system))
}
