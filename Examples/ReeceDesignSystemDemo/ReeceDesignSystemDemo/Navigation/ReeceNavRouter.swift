//
//  NavRouter.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 31/08/25.
//


import SwiftUI

/// Rutas de la demo.
enum ReeceRoute: Hashable {
    case home
    case primary
    case secondary
    case support
    case colorDetail(name: String, hex: String)
    case fontsview
    case fontDetail(font: DemoFontFamily)
}

/// Router observable con un `NavigationPath` compartido.
@MainActor
final class ReeceNavRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    var canGoBack: Bool { !path.isEmpty }
    
    func push(_ route: ReeceRoute) {
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
