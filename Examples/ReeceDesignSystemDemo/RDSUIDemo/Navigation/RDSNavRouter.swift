//
//  NavRouter.swift
//  RDSDesignSystemDemo
//
//  Created by Carlos Lopez on 31/08/25.
//


import SwiftUI
import RDSUI

/// Rutas de la demo.
enum RDSRoute: Hashable {
    case home
    case primary
    case secondary
    case support
    case colorDetail(name: String, hex: String)
    case fontsview
    case fontDetail(font: DemoFontFamily)
    case iconsView
    case iconsGalerryView(iconCategory: RDSIconCategory)
    case buttonsView
    case buttonDetailView(variant: RDSButtonVariant)
}

/// Router observable con un `NavigationPath` compartido.
@MainActor
final class RDSNavRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    var canGoBack: Bool { !path.isEmpty }
    
    func push(_ route: RDSRoute) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
