// ReeceToolbarModifier.swift
import SwiftUI
import RDSUI

struct ReeceNavBarConfig {
    var title: String = ""
    var showBack: Bool = true
    var overrideBackground: Color? = nil
    var leading: () -> any View = { EmptyView() }
    var trailing: () -> any View = { EmptyView() }
}

struct ReeceNavBarModifier: ViewModifier {
    @EnvironmentObject private var router: ReeceNavRouter
    let cfg: ReeceNavBarConfig
    private let barHeight: CGFloat = 56
    
    func body(content: Content) -> some View {
        content
            .padding(.top, barHeight)
            .toolbar(.hidden, for: .navigationBar)
            .toolbarVisibility(.hidden, for: .navigationBar)
            .navigationBarBackButtonHidden(true)
            .overlay(alignment: .top) {
                ReeceNavBar(
                    title: cfg.title,
                    showBack: cfg.showBack && router.canGoBack,
                    overrideBackground: cfg.overrideBackground,
                    leading: { AnyView(cfg.leading()) },
                    trailing: { AnyView(cfg.trailing()) },
                    onBack: { router.pop() }
                )
            }
    }
}

extension View {
    func reeceNavigationBar(
        title: String,
        showBack: Bool = true,
        overrideBackground: Color? = nil,
        @ViewBuilder leading: @escaping () -> some View = { EmptyView() },
        @ViewBuilder trailing: @escaping () -> some View = { EmptyView() }
    ) -> some View {
        let cfg = ReeceNavBarConfig(
            title: title,
            showBack: showBack,
            overrideBackground: overrideBackground,
            leading: { AnyView(leading()) },
            trailing: { AnyView(trailing()) }
        )
        return modifier(ReeceNavBarModifier(cfg: cfg))
    }
}
