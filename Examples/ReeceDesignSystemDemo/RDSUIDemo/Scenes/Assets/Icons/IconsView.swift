//
//  IconsView.swift
//  RDSUIDemo
//
//  Created by Carlos Lopez on 07/09/25.
//

import SwiftUI
import RDSUI

// MARK: - Row

private struct IconCategoryRow: View {
    let item: RDSIconCategory
    
    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            // Title rendered using the family in a headline token
            Text(item.rawValue.capitalized)
                .rdsTextStyle(.h5R)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
        }
        .contentShape(Rectangle())
    }
}

struct IconsView: View {
    @Environment(\.colorScheme) private var systemScheme
    @Environment(\.rdsTheme) private var themeMode: Binding<RDSThemeMode>
    @EnvironmentObject private var router: RDSNavRouter
    let onSelect: (RDSIconCategory) -> Void
    var body: some View {
        let cellBg = themeMode.wrappedValue.resolve(systemScheme) == .dark ? Color(white: 0.50) : Color.white
        let background = themeMode.wrappedValue.resolve(systemScheme) == .dark ? Color(white: 0.30) : Color(white: 0.90)
        ZStack {
            List {
                Section(footer: Text("Tap a category to explore it in detail")) {
                    ForEach(RDSIconCategory.allCases, id: \.self) { item in
                        IconCategoryRow(item: item)
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
        .rdsNavigationBar(title: "Reece DS - Icons", trailing: {
            RDSThemeMenuView()
        })
    }
}
