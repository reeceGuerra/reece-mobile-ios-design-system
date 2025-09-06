// RDSToolbarModifier.swift
import SwiftUI
import RDSUI

struct RDSNavBarConfig {
    var title: String = ""
    var showBack: Bool = true
    var overrideBackground: Color? = nil
    var leading: () -> any View = { EmptyView() }
    var trailing: () -> any View = { EmptyView() }
}

struct RDSNavBarModifier: ViewModifier {
    @EnvironmentObject private var router: RDSNavRouter
    let cfg: RDSNavBarConfig
    private let barHeight: CGFloat = 56
    
    func body(content: Content) -> some View {
        content
            .padding(.top, barHeight)
            .toolbar(.hidden, for: .navigationBar)
            .toolbarVisibility(.hidden, for: .navigationBar)
            .navigationBarBackButtonHidden(true)
            .overlay(alignment: .top) {
                RDSNavBar(
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
    func rdsNavigationBar(
        title: String,
        showBack: Bool = true,
        overrideBackground: Color? = nil,
        @ViewBuilder leading: @escaping () -> some View = { EmptyView() },
        @ViewBuilder trailing: @escaping () -> some View = { EmptyView() }
    ) -> some View {
        let cfg = RDSNavBarConfig(
            title: title,
            showBack: showBack,
            overrideBackground: overrideBackground,
            leading: { AnyView(leading()) },
            trailing: { AnyView(trailing()) }
        )
        return modifier(RDSNavBarModifier(cfg: cfg))
    }
}
