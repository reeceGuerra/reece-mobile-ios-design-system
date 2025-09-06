//
//  HomeView.swift
//  RDSDesignSystemDemo
//
//  Created by Carlos Lopez on 30/08/25.
//
import SwiftUI
import RDSUI

struct ColorsView: View {
    @Environment(\.colorScheme) private var systemScheme
    @Environment(\.rdsTheme) private var themeMode: Binding<RDSThemeMode>
    @EnvironmentObject private var router: RDSNavRouter
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
                    NavigationLink("Primary", value: RDSRoute.primary)
                    NavigationLink("Secondary", value: RDSRoute.secondary)
                    NavigationLink("Support", value: RDSRoute.support)
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
            title: "Reece DS - Colors", trailing:  {
                RDSThemeMenuView()
        })
    }
}

#Preview {
    ColorsView()
        .environmentObject(RDSNavRouter())
        .environment(\.rdsTheme, .constant(.system))
}
