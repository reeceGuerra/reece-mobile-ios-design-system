//
//  RDSDesignSystemDemoApp.swift
//  RDSDesignSystemDemo
//
//  Created by Carlos Lopez on 30/08/25.
//

import SwiftUI
import RDSUI

@main
struct RDSDesignSystemDemoApp: App {
    init() {
        _ = RDSFontRegister.registerAllFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .rdsFontFamily(.roboto)
        }
    }
}
