//
//  ReeceTopBar.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 31/08/25.
//


import SwiftUI
import ReeceDesignSystem

/// Top bar propio (no usa UINavigationBar).
/// - Muestra título a la izquierda.
/// - Botón Back opcional (aparece cuando hay algo en el router.path).
/// - Menú de theme a la derecha, usando tu HomeViewModel.
/// - Colores reactivos al scheme efectivo.
struct ReeceTopBar: View {
    @Environment(\.colorScheme) private var systemScheme
    @EnvironmentObject private var vm: HomeViewModel
    @EnvironmentObject private var router: NavRouter

    let title: String
    var overrideBackground: Color? = nil

    // Derivados de UI (idénticos a tu toolbar previo)
    private var textColor: Color { vm.primaryTextColor(using: systemScheme) }
    private var menuBg: Color { vm.menuLabelBackground(using: systemScheme) }
    private var menuBorder: Color { vm.menuLabelBorder(using: systemScheme) }
    private var menuIcon: String { vm.imageThemeSystem(using: systemScheme) }
    private var showBack: Bool { !router.path.isEmpty }

    var body: some View {
        HStack(spacing: 12) {
            // Back si hay algo en el path
            if showBack {
                Button {
                    router.pop()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(textColor)
                }
            }

            Text(title)
                .font(.title)
                .foregroundStyle(textColor)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer()

            Menu {
                ForEach(ReeceThemeMode.allCases, id: \.self) { theme in
                    Button { vm.themeMode = theme } label: {
                        Label(theme.title, systemImage: vm.themeMode == theme ? "checkmark" : "")
                    }
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
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 10)
        .background(
            (overrideBackground ?? vm.backgroundColor(using: systemScheme))
                           .overlay(Divider(), alignment: .bottom)
        )
    }
}
