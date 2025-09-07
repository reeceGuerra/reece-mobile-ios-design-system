//
//  IconsGalleryView.swift
//  RDSUIDemo
//
//  Created by Carlos Lopez on 07/09/25.
//

import SwiftUI
import RDSUI

struct IconsGalleryView: View {
    @Environment(\.colorScheme) private var systemScheme
    @Environment(\.rdsTheme) private var themeMode: Binding<RDSThemeMode>
    @EnvironmentObject private var router: RDSNavRouter
    var category: RDSIconCategory
    
    /// Number of columns to show in the grid.
    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 3
    )
    
    var body: some View {
        let background = themeMode.wrappedValue.resolve(systemScheme) == .dark ? Color(white: 0.30) : Color(white: 0.90)
        ZStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(RDSIcon.icons(in: category), id: \.self) { icon in
                        GeometryReader { proxy in
                            // Ensure each cell is a square using the width of the grid cell
                            let side = proxy.size.width
                            Image(rds: icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: side, height: side)
                                .foregroundColor(RDSColors.primary.DarkBlue.color(.t100, using: systemScheme))
                                .clipped()
                                .cornerRadius(8)
                        }
                        .aspectRatio(1, contentMode: .fit) // forces square shape
                    }
                }
                .padding()
            }
            .background(background)
        }
    }
}
