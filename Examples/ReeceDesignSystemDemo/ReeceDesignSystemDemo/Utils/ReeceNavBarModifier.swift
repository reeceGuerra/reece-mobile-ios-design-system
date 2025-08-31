// ReeceToolbarModifier.swift
import SwiftUI
import ReeceDesignSystem

struct ReeceNavBarConfig {
    var title: String = ""
    var showBack: Bool = true
    var overrideBackground: Color? = nil
    var leading: () -> any View = { EmptyView() }
    var trailing: () -> any View = { EmptyView() }
}

private struct ReeceNavBarKey: EnvironmentKey {
    static let defaultValue = ReeceNavBarConfig()
}
extension EnvironmentValues {
    var reeceNavBarConfig: ReeceNavBarConfig {
        get { self[ReeceNavBarKey.self] }
        set { self[ReeceNavBarKey.self] = newValue }
    }
}

struct ReeceNavBarModifier: ViewModifier {
    @EnvironmentObject private var router: ReeceNavRouter
    @Environment(\.reeceNavBarConfig) private var cfg

    func body(content: Content) -> some View {
        content
            .toolbar(.hidden, for: .navigationBar)
            .toolbarVisibility(.hidden, for: .navigationBar)
            .navigationBarBackButtonHidden(true)
            .safeAreaInset(edge: .top) {
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
        @ViewBuilder leading: @escaping () -> any View = { EmptyView() },
        @ViewBuilder trailing: @escaping () -> any View = { EmptyView() }
    ) -> some View {
        self.environment(\.reeceNavBarConfig, .init(
            title: title,
            showBack: showBack,
            overrideBackground: overrideBackground,
            leading: leading,
            trailing: trailing
        ))
        .modifier(ReeceNavBarModifier())
    }
}
