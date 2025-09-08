# RDSUI – Reece Design System for iOS & macOS

[![Swift](https://img.shields.io/badge/Swift-6-orange?logo=swift)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-16%2B-blue?logo=xcode)](https://developer.apple.com/xcode/)
[![iOS](https://img.shields.io/badge/iOS-17%2B-blue?logo=apple)](https://developer.apple.com/ios/)
[![macOS](https://img.shields.io/badge/macOS-15%2B-lightgrey?logo=apple)](https://developer.apple.com/macos/)
[![CI](https://github.com/reeceGuerra/reece-mobile-ios-design-system/actions/workflows/ci.yml/badge.svg)](https://github.com/reeceGuerra/reece-mobile-ios-design-system/actions/workflows/ci.yml)
[![Release](https://github.com/reeceGuerra/reece-mobile-ios-design-system/actions/workflows/release.yml/badge.svg)](https://github.com/reeceGuerra/reece-mobile-ios-design-system/actions/workflows/release.yml)
[![Latest Release](https://img.shields.io/github/v/release/reeceGuerra/reece-mobile-ios-design-system?include_prereleases)](https://github.com/reeceGuerra/reece-mobile-ios-design-system/releases)
[![Coverage](https://img.shields.io/endpoint?url=https://reeceGuerra.github.io/reece-mobile-ios-design-system/coverage/endpoint.json)](https://reeceGuerra.github.io/reece-mobile-ios-design-system/coverage/)

**RDSUI** is the Swift-based design system for iOS and macOS at Reece, providing a unified set of tokens, assets, and reusable components to ensure consistency across apps.

---

## ✨ Features

- 🎨 **Color system**  
  Semantic colors grouped into families (`Primary`, `Secondary`, `Support`) with light/dark scheme support.

- 🔤 **Typography**  
  Scalable text styles, font families, weights, and custom registration of reusable fonts.

- 🔘 **Reusable components**  
  SwiftUI-based buttons and helpers to apply design tokens consistently.

- 🧪 **Test coverage**  
  Unit tests included for colors, fonts, typography, icons, and buttons.
  **Current coverage:** see the live badge above (auto-updated on every CI run).


---

## 📦 Installation

This package is distributed via **Swift Package Manager (SPM)**.

### Xcode

1. In Xcode, go to  
   `File > Add Packages…`

2. Enter the repository URL:  
   ```text
   https://github.com/reeceGuerra/reece-mobile-ios-design-system.git
   ```

3. Select the product **`RDSUI`** and add it to your target.

### Package.swift

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MyApp",
    platforms: [
        .iOS(.v17), .macOS(.v15)
    ],
    dependencies: [
        .package(
            url: "https://github.com/reeceGuerra/reece-mobile-ios-design-system.git",
            from: "0.6.10"
        )
    ],
    targets: [
        .target(
            name: "MyApp",
            dependencies: [
                .product(name: "RDSUI", package: "reece-mobile-ios-design-system")
            ]
        )
    ]
)
```

> **Note:** SwiftPM resolves versions from Git tags. Always pin a minimum version (`from:`) to ensure stability.

---

## 🚀 Quick Start

```swift
import SwiftUI
import RDSUI
```

### 1) Colors

```swift
struct ColorExample: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(spacing: 12) {
            // Family + tone
            let darkBlue = RDSColors.Primary.DarkBlue.color(.t60, using: scheme)
            Circle().fill(darkBlue).frame(width: 48, height: 48)

            // HEX
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.rds("#003766"))
                .frame(height: 24)

            // Random
            Capsule()
                .fill(RDSColors.random(using: scheme))
                .frame(height: 16)
        }
    }
}
```

### 2) Typography

```swift
struct TypographyExample: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Heading").rdsTextStyle(.h3R)
            Text("Italic").rdsTextStyle(.body, slant: .italic, color: Color.rds("#003766"))
            Text("Roboto").rdsTextStyle(.h3M, family: .roboto)
        }
    }
}
```

### 3) Button

```swift
struct ButtonExample: View {
    var body: some View {
        VStack {
            RDSButton(title: "Continue") { }
            RDSButton(title: "Learn more", variant: .secondary, type: .textLink, size: .small) { }
            RDSButton(title: "Next",
                      variant: .alternative, type: .default, size: .iconRight, state: .highlighted,
                      icon: Image(systemName: "arrow.right")) { }
        }
    }
}
```

---

## 🎨 Colors

RDSUI provides a semantic color system organized in **families** (Primary, Secondary, Support) with **tones**.

### When `.fill` expects a ShapeStyle

Use `RDSStyle` to wrap colors or gradients into `AnyShapeStyle`:

```swift
let base = RDSColors.Primary.DarkBlue.color(.t60, using: scheme)

RoundedRectangle(cornerRadius: 12)
    .fill(RDSStyle.solid(base).style)

let c1 = RDSColors.Primary.DarkBlue.color(.t100, using: scheme)
let c2 = RDSColors.Primary.LightBlue.color(.t100, using: scheme)
let gradient = LinearGradient(colors: [c1, c2], startPoint: .leading, endPoint: .trailing)

RoundedRectangle(cornerRadius: 12)
    .fill(RDSStyle.gradient(gradient).style)
```

---

## 🔤 Typography

### Basic usage

```swift
Text("Heading 1").rdsTextStyle(.h1B)
Text("Body").rdsTextStyle(.body)
```

### Overrides

```swift
Text("Custom")
    .rdsTextStyle(.body, slant: .italic, color: Color.rds("#003766"))
```

### Global override

```swift
@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .reeceFontFamily(.roboto) // global default
        }
    }
}
```

### Tokens

- **Headings:** h1B/h1M/h1R … h5B/h5M/h5R  
- **Body:** body, caption, code  
- **Buttons:** buttonM, buttonS  

Dynamic Type is supported via SwiftUI `Font.TextStyle` anchors.

---

## 🔘 RDSButton

Design-system button with **variants**, **types**, **sizes**, and **states**.

### Variants & Types

| Variant       | `.default` | `.textLink` |
|---------------|------------|-------------|
| `.primary`    | ✅          | ✅           |
| `.secondary`  | ✅          | ✅           |
| `.alternative`| ✅          | ❌ *(not supported)* |

### Example

```swift
RDSButton(title: "Submit", state: .loading) { }
RDSButton(title: "Saved", state: .confirmed) { }
```

---

## 📱 Demo App

Located at `Examples/ReeceDesignSystemDemo/RDSUIDemo.xcodeproj`.  
Open in **Xcode 16+**, select scheme **RDSDesignSystemDemo**, run on iOS 17+.

Showcases:
- Colors
- Typography
- Icons
- Buttons

### Preview

![Demo Preview](docs/demo.gif)

---

## 🧪 Testing

Uses **Swift Testing** (requires Xcode 16+ / Swift 6).

- Run all tests: `swift test`  
- Or in Xcode: **Product > Test**

Coverage includes: Colors, Typography, Fonts, Icons, Buttons.

---

## 🗒️ Changelog & Releases

See [CHANGELOG.md](./CHANGELOG.md) and [GitHub Releases](https://github.com/reeceGuerra/reece-mobile-ios-design-system/releases).

- **SemVer** (with pre-1.0 caveat: minor versions may break).  
- Tags: `v0.x.y` (e.g., v0.6.10).  
- CI must pass before Release workflow runs.

---

## 🤝 Contributing

- Open a PR for all changes.  
- Follow the design team guidelines.  
- Use commit conventions:

Must be one of the following:

* `[BUILD]: Changes that affect the build system or external dependencies (example scopes: deps, deps-dev)`
* `[CI]: Changes to our CI configuration files and scripts (example scopes: Jenkins, Circle, BrowserStack, SauceLabs)`
* `[DOCS]: Documentation only changes`
* `[FEAT]: A new feature`
* `[FIX]: A bug fix`
* `[PERF]: A code change that improves performance`
* `[REFACTOR]: A code change that neither fixes a bug nor adds a feature`
* `[STYLE]: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)`
* `[TEST]: Adding missing tests or correcting existing tests`

Examples:
```
    - [DOCS]: document developing locally in docker
    - [FEAT]: add WebAuthn support
    - [FEAT]: add post about useful tips for developers
    - [REFACTOR]: cleanup exception handling
    - [FIX]: typo
    - [FIX]: missing null safety check
    - [FIX]: invalid catch block
    - [BUILD](deps): update dependencies
    - [CI]: use clean Jenkinsfile
    - [STYLE]: fixed
    - [STYLE]: add custom rule for line length
```


---

## 📄 License

This project is proprietary and distributed internally at Reece.  
No open-source license applies. Please do not copy, distribute, or reuse outside the organization.

