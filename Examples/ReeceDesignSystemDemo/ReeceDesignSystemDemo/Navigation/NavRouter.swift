//
//  NavRouter.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 31/08/25.
//


import SwiftUI

/// Rutas de la demo.
enum ReeceRoute: Hashable {
    case primary
    case secondary
    case support
    case colorDetail(name: String, hex: String)
}

/// Router observable con un `NavigationPath` compartido.
final class NavRouter: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ route: ReeceRoute) { path.append(route) }
    func pop() { if !path.isEmpty { path.removeLast() } }
    func popToRoot() { path = NavigationPath() }
}
