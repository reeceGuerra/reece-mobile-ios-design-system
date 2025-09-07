//
//  ButtonsView.swift
//  RDSUIDemo
//
//  Created by Carlos Lopez on 07/09/25.
//

import SwiftUI
import RDSUI

struct ButtonsView: View {
    @Environment(\.colorScheme) private var systemScheme
    @Environment(\.rdsTheme) private var themeMode: Binding<RDSThemeMode>
    @EnvironmentObject private var router: RDSNavRouter
//    let onSelect: (DemoFontFamily) -> Void
    
    var body: some View {
        let cellBg = themeMode.wrappedValue.resolve(systemScheme) == .dark ? Color(white: 0.50) : Color.white
        let background = themeMode.wrappedValue.resolve(systemScheme) == .dark ? Color(white: 0.30) : Color(white: 0.90)
        ZStack {
            List {
                Section(footer: Text("Tap a Variant to explore it in detail")) {
                    NavigationLink("Primary", value: RDSRoute.buttonDetailView(variant: .primary))
                    NavigationLink("Secondary", value: RDSRoute.buttonDetailView(variant: .secondary))
                    NavigationLink("Alternative", value: RDSRoute.buttonDetailView(variant: .alternative))
                    
                }
                .listRowBackground(cellBg)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(background)
            .rdsTextStyle(.body)
        }
        .rdsNavigationBar(title: "Reece DS - Buttons", trailing: {
            RDSThemeMenuView()
        })
    }
}

