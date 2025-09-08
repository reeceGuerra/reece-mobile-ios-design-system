//
//  ButtonDetailView.swift
//  RDSUIDemo
//
//  Created by Carlos Lopez on 07/09/25.
//

import SwiftUI
import RDSUI

struct DemoButtonType: Identifiable, Hashable {
    let id = UUID()
    let type: RDSButtonType
    let displayName: String
    
    static let all: [DemoButtonType] = [
        .init(type: .default, displayName: "Default"),
        .init(type: .textLink, displayName: "Text Link")
    ]
}

struct DemoButtonSize: Identifiable, Hashable {
    let id = UUID()
    let size: RDSButtonSize
    let displayName: String
    
    static let all: [DemoButtonSize] = [
        .init(size: .default, displayName: "Default"),
        .init(size: .small, displayName: "Small"),
        .init(size: .large, displayName: "Large"),
        .init(size: .iconLeft, displayName: "Icon Left"),
        .init(size: .iconRight, displayName: "Icon Right")
    ]
}

struct ButtonDetailView: View {
    @Environment(\.colorScheme) private var systemScheme
    @Environment(\.rdsTheme) private var themeMode: Binding<RDSThemeMode>
    @EnvironmentObject private var router: RDSNavRouter
    @State private var buttonTypeSelection: RDSButtonType = .default
    @State private var buttonSizeSelection: RDSButtonSize = .default
    var variant: RDSButtonVariant
    
    var body: some View {
        let background = themeMode.wrappedValue.resolve(systemScheme) == .dark ? Color(white: 0.30) : Color(white: 0.90)
        ZStack {
            background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Type", selection: $buttonTypeSelection) {
                        ForEach(DemoButtonType.all) { selected in
                            Text(selected.displayName).tag(selected.type)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("Size", selection: $buttonSizeSelection) {
                        ForEach(DemoButtonSize.all) { selected in
                            Text(selected.displayName).tag(selected.size)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    RDSButton(title: "RDSButton",
                              variant: variant,
                              type: $buttonTypeSelection.wrappedValue,
                              size: $buttonSizeSelection.wrappedValue,
                              state: .normal,
                              icon: Image(rds: RDSIcon.add)) { }
                    
                    RDSButton(title: "RDSButton",
                              variant: variant,
                              type: $buttonTypeSelection.wrappedValue,
                              size: $buttonSizeSelection.wrappedValue,
                              state: .highlighted,
                              icon: Image(rds: RDSIcon.add)) { }
                    
                    RDSButton(title: "RDSButton",
                              variant: variant,
                              type: $buttonTypeSelection.wrappedValue,
                              size: $buttonSizeSelection.wrappedValue,
                              state: .disabled,
                              icon: Image(rds: RDSIcon.add)) { }
                    
                    RDSButton(title: "RDSButton",
                              variant: variant,
                              type: $buttonTypeSelection.wrappedValue,
                              size: $buttonSizeSelection.wrappedValue,
                              state: .loading,
                              icon: Image(rds: RDSIcon.add)) { }
                    
                    RDSButton(title: "RDSButton",
                              variant: variant,
                              type: $buttonTypeSelection.wrappedValue,
                              size: $buttonSizeSelection.wrappedValue,
                              state: .confirmed,
                              icon: Image(rds: RDSIcon.add)) { }
                    
                }
                .padding()
            }
            .background(background)
        }
        .rdsNavigationBar(title: "Buttons - \("\(variant)".capitalized)", trailing: {
            RDSThemeMenuView()
        })
    }
}
