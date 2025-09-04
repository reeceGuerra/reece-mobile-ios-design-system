//
//  ReeceDesignSystemDemoApp.swift
//  ReeceDesignSystemDemo
//
//  Created by Carlos Lopez on 30/08/25.
//

import SwiftUI
import ReeceDesignSystem

@main
struct ReeceDesignSystemDemoApp: App {
    init() {
        _ = ReeceFontRegister.registerAllFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .reeceFontFamily(.roboto)
        }
    }
}
