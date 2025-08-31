//
//  ContentView.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 30/08/25.
//

import SwiftUI
import ReeceDesignSystem

struct ContentView: View {
    @Environment(\.colorScheme) private var systemScheme
    @State private var themeMode: ReeceThemeMode = .system

    var body: some View {
        NavigationStack {
            List {
                Section("Families") {
                    NavigationLink("Primary") { PrimaryView(mode: $themeMode, systemScheme: systemScheme) }
//                    NavigationLink("Secondary") { SecondaryView(mode: $themeMode, systemScheme: systemScheme) }
//                    NavigationLink("Support") { SupportView(mode: $themeMode, systemScheme: systemScheme) }
                }
            }
            .navigationTitle("Reece Design System")
            .toolbar {
                Menu {
                    Button("System") { themeMode = .system }
                    Button("Light") { themeMode = .light }
                    Button("Dark") { themeMode = .dark }
                } label: {
                    Label("Theme", systemImage: "paintpalette")
                }
            }
        }
        .onChange(of: themeMode) { _, newValue in
            ReeceTheme.mode = newValue
        }
    }
}


#Preview {
    ContentView()
}
