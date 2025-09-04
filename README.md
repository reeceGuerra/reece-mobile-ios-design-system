# Reece Mobile iOS Design System

![Swift 5.9](https://img.shields.io/badge/Swift-5.9-orange?logo=swift)
![SPM Compatible](https://img.shields.io/badge/SPM-Compatible-green?logo=swift)
![iOS 17+](https://img.shields.io/badge/iOS-17%2B-blue?logo=apple)
![macOS 14+](https://img.shields.io/badge/macOS-14%2B-lightgrey?logo=apple)

A Swift-based **design system** for iOS and macOS, providing a unified set of **colors, typography, and reusable components** to ensure consistency across Reece’s mobile apps.

## ✨ Features

- 🎨 **Color system**  
  Semantic colors grouped into families (`Primary`, `Secondary`, `Support`) with light/dark scheme support.

- 🔤 **Typography**  
  Scalable text styles, font families, weights, and custom registration of reusable fonts.

- 🧩 **Reusable components**  
  SwiftUI-based modifiers and helpers to apply design tokens consistently.

- 🧪 **Test coverage**  
  Unit tests included for fonts, palettes, and theme utilities.

---

## 📦 Installation

This package is distributed via **Swift Package Manager (SPM)**.

1. In Xcode, go to:  
   `File > Add Packages...`

2. Enter the repository URL:  
   ```text
   https://github.com/reeceGuerra/reece-mobile-ios-design-system.git
   ```

3. Choose the latest version or `main` branch.

---

## 🚀 Usage

### Colors

#### Solid Color

```swift
import ReeceDesignSystem
import SwiftUI

struct ExampleView: View {
    var body: some View {
        Rectangle()
            .fill(
                ReeceStyle.solid(
                    ReeceColors.primary.DarkBlue.color(.t100, using: .light)
                ).style
            )
            .frame(height: 100)
    }
}
```

#### Gradient

```swift
Rectangle()
    .fill(
        ReeceStyle.gradient(
            LinearGradient(
                colors: [
                    ReeceColors.primary.DarkBlue.color(.t100, using: .light),
                    ReeceColors.primary.DarkBlue.color(.t300, using: .light)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        ).style
    )
    .frame(height: 100)
```

### Typography

### Global font override & exceptions
Set a default font family for your app (or any subtree) via the SwiftUI environment:

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

Opt out locally by passing an explicit `family:` at the call site:

```swift
Text("System tag")
  .reeceText(.body, family: .system)
```

Token-level override (optional): a token may set `preferredFamily` in its `ReeceTextSpec` to enforce a specific family, regardless of the global default. An explicit call-site override still wins.


```swift
Text("Hello Reece!")
    .reeceText(.headingLarge, slant: .italic, color: .primary)
```

### Random Color Helper

```swift
let color = ReeceColorEngine.random()
```

---

## 📂 Project Structure

```
ReeceDesignSystem/
├─ Sources/
│  └─ ReeceDesignSystem/   # Core design system code
│
├─ Tests/
│  └─ ReeceDesignSystemTests/  # Unit tests
│
└─ Examples/
   └─ ReeceDesignSystemDemo/   # SwiftUI demo app
```

---

## 🧪 Running Tests

Run all unit tests with:

```bash
swift test
```

Or inside Xcode via **Product > Test**.

---

## 🛠 Requirements

- iOS 17+ / macOS 14+
- Xcode 15+
- Swift 5.9+

---


