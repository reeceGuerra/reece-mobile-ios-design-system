//
//  FontsView.swift
//  RDSDesignSystemDemo
//
//  Created by Carlos Lopez on 03/09/25.
//
//  Overview
//  --------
//  Lists all font families supported by the Design System and renders each row
//  using that family so you can preview the typeface at a glance.
//  The detail screen will be wired up later.
//
//  Integration
//  -----------
//  Drop this file under:
//  Examples/RDSDesignSystemDemo/RDSDesignSystemDemo/Scenes/Typography/
//  You can push it from your Home/Colors menu once you add a new route.
//

import SwiftUI
import RDSUI

// MARK: - Model (local to demo)

struct DemoFontFamily: Identifiable, Hashable {
    let id = UUID()
    let family: RDSFontFamily
    let displayName: String
    
    static let all: [DemoFontFamily] = [
        .init(family: .system, displayName: "System"),
        .init(family: .roboto, displayName: "Roboto"),
        .init(family: .openSans, displayName: "Open Sans"),
        .init(family: .helveticaNeueLTPro, displayName: "Helvetica Neue LT Pro")
    ]
}

// MARK: - Row

private struct FontFamilyRow: View {
    let item: DemoFontFamily
    
    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            // Title rendered using the family in a headline token
            Text(item.displayName)
                .rdsTextStyle(.h5M, family: item.family)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
        }
        .contentShape(Rectangle())
    }
}

// MARK: - List View

struct FontsView: View {
    @Environment(\.colorScheme) private var systemScheme
    @Environment(\.rdsTheme) private var themeMode: Binding<RDSThemeMode>
    @EnvironmentObject private var router: RDSNavRouter
    let onSelect: (DemoFontFamily) -> Void
    
    var body: some View {
        let cellBg = themeMode.resolve(using: systemScheme) == .dark ? Color(white: 0.50) : Color.white
        let background = themeMode.resolve(using: systemScheme) == .dark ? Color(white: 0.30) : Color(white: 0.90)
        ZStack {
            List {
                Section(footer: Text("Tap a family to explore it in detail")) {
                    ForEach(DemoFontFamily.all) { item in
                        FontFamilyRow(item: item)
                            .onTapGesture {
                                onSelect(item)
                            }
                    }
                    
                    .listRowBackground(cellBg)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(background)
            .rdsTextStyle(.body)
        }
        .rdsNavigationBar(title: "Reece DS - Typography", trailing: {
            RDSThemeMenuView()
        })
    }
}

#Preview {
    NavigationStack {
        FontsView(onSelect: { _ in })
            .environmentObject(RDSNavRouter())
            .environment(\.rdsTheme, .constant(.system))
    }
}
