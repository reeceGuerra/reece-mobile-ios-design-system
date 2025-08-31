// ReeceToolbarModifier.swift
import SwiftUI
import ReeceDesignSystem

struct ReeceToolbarModifier: ViewModifier {
    @Environment(\.colorScheme) private var systemScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var vm: HomeViewModel

    let title: String
    let showBack: Bool
    let hideSystemBackButton: Bool
    let visible: Bool

    private var textColor: Color { vm.primaryTextColor(using: systemScheme) }
    private var menuBg: Color { vm.menuLabelBackground(using: systemScheme) }
    private var menuBorder: Color { vm.menuLabelBorder(using: systemScheme) }
    private var menuIcon: String { vm.imageThemeSystem(using: systemScheme) }

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(hideSystemBackButton && showBack)
            .toolbar {
                if visible {
                    if showBack {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.backward")
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(textColor)
                            }
                        }
                    }

                    ToolbarItem(placement: .topBarLeading) {
                        Text(title)
                            .font(.title)
                            .foregroundStyle(textColor)
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            ForEach(ReeceThemeMode.allCases, id: \.self) { theme in
                                Button { vm.themeMode = theme } label: {
                                    Label(theme.title,
                                          systemImage: vm.themeMode == theme ? "checkmark" : "")
                                }
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: menuIcon)
                                Text(vm.themeMode.title)
                                    .font(.callout.weight(.semibold))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .foregroundStyle(textColor)
                            .background(menuBg)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(menuBorder, lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
    }
}

extension View {
    func reeceToolbar(
        title: String,
        showBack: Bool = false,                // en Home se queda false
        hideSystemBackButton: Bool = true,     // oculta back del sistema si usas el tuyo
        visible: Bool = true
    ) -> some View {
        modifier(ReeceToolbarModifier(
            title: title,
            showBack: showBack,
            hideSystemBackButton: hideSystemBackButton,
            visible: visible
        ))
    }
}
