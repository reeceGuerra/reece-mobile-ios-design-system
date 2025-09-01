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
    @Environment(\.reeceTheme) private var themeMode: Binding<ReeceThemeMode>
    @EnvironmentObject private var router: ReeceNavRouter
    @StateObject private var vm = HomeViewModel()
    
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
        .toolbar(.hidden, for: .navigationBar)
        .toolbarVisibility(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .reeceNavigationBar(
            title: "Reece DS",
            showBack: false, trailing:  {
                MenuView()
        })
    }
}

struct MenuView: View {
    @Environment(\.reeceTheme) private var themeMode: Binding<ReeceThemeMode>
    @Environment(\.colorScheme) private var systemScheme
    
    var body: some View {
        let menuBg: Color =  ReeceThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode.wrappedValue) == .dark
        ? Color.white.opacity(0.12)
        : Color.black.opacity(0.08)
        
        let menuBorder: Color = ReeceThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode.wrappedValue) == .dark
        ? Color.white.opacity(0.22)
        : Color.black.opacity(0.18)
        
        let menuIcon: String = ReeceThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode.wrappedValue) == .dark
        ? "moon.stars.fill"
        : "sun.max.fill"
        let textColor = ReeceThemeMode.effectiveScheme(using: systemScheme, themeMode: themeMode.wrappedValue) == .dark
        ? Color.white.opacity(0.92)
        : Color.black.opacity(0.9)
        
        Menu {
            ForEach(ReeceThemeMode.allCases, id: \.self) { theme in
                Button {
                    themeMode.wrappedValue = theme
                } label: {
                    if themeMode.wrappedValue == theme {
                        Label(theme.title, systemImage: "checkmark")
                    } else {
                        Text(theme.title)
                    }
                }
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: menuIcon)
                Text(themeMode.wrappedValue.title).font(.callout.weight(.semibold))
            }
            .padding(.horizontal, 12).padding(.vertical, 8)
            .foregroundStyle(textColor)
            .background(menuBg)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(menuBorder, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(ReeceNavRouter())
        .environment(\.reeceTheme, .constant(.system))
}
