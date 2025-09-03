//
//  ReeceText+Modifier.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 02/09/25.
//  Overview
//  --------
//  Two APIs:
//
//  1) Precise Text builder (preferred):
//     ReeceText(_:token:slant:color:family:designScale:)
//     - Converts design px → pt.
//     - Applies exact line-height via NSMutableParagraphStyle (UIKit/AppKit) + NSAttributedString bridge.
//     - Applies kerning from percent (%) using base point size.
//     - Resolves fonts via ReeceFontResolver (system/Roboto) and applies italic fallback.
//
//  2) ViewModifier fallback:
//     .reeceText(_:slant:color:family:designScale:)
//     - For existing Text values.
//     - Approximates line-height using `.lineSpacing` with base pt.
//     - Applies kerning and italic at view level.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
typealias PlatformParagraphStyle = NSMutableParagraphStyle
#elseif canImport(AppKit)
import AppKit
typealias PlatformParagraphStyle = NSMutableParagraphStyle
#endif

// MARK: - Precise Text builder

@available(iOS 15.0, macOS 12.0, *)
public func ReeceText(_ string: String,
                      token: ReeceTextStyleToken,
                      slant: ReeceFontSlant? = nil,
                      color: Color? = nil,
                      family: ReeceFontFamily = .system,
                      designScale: CGFloat? = nil) -> Text {
    var spec = token.spec
    if let s = slant { spec = spec.with(slant: s) }

    // 1) Base pt (px→pt)
    let basePt = spec.basePointSize(usingScale: designScale)

    // 2) Resolve font (system/custom) + italic fallback flag
    let resolved = ReeceFontResolver.resolve(for: spec, family: family, basePointSize: basePt)

    // 3) Kerning (pt) from design percent
    let kernPoints: CGFloat? = {
        guard let percent = spec.letterSpacingPercent else { return nil }
        return (percent / 100.0) * basePt
    }()

    // 4) Paragraph style (UIKit/AppKit) + NSAttributedString → AttributedString bridge
    let paragraph = PlatformParagraphStyle()
    if let multiple = spec.lineHeightMultiple() {
        paragraph.lineHeightMultiple = multiple
    }

    var nsAttributes: [NSAttributedString.Key: Any] = [
        .paragraphStyle: paragraph
    ]
    if let k = kernPoints {
        nsAttributes[.kern] = k
    }

    let nsAttr = NSAttributedString(string: string, attributes: nsAttributes)
    let attr = AttributedString(nsAttr)

    var text = Text(attr).font(resolved.font)
    if let color = color {
        text = text.foregroundStyle(color)
    }
    if resolved.needsViewItalic {
        text = text.italic()
    }
    return text
}

// MARK: - ViewModifier fallback

public struct ReeceTextModifier: ViewModifier {
    let token: ReeceTextStyleToken
    let slant: ReeceFontSlant?
    let color: Color?
    let family: ReeceFontFamily
    let designScale: CGFloat?

    public func body(content: Content) -> some View {
        var spec = token.spec
        if let s = slant { spec = spec.with(slant: s) }

        let basePt = spec.basePointSize(usingScale: designScale)

        // Approximate line-height with .lineSpacing
        let lineSpacing: CGFloat = {
            guard let multiple = spec.lineHeightMultiple() else { return 0 }
            return max((multiple - 1.0) * basePt, 0)
        }()

        let kernPoints: CGFloat = {
            guard let percent = spec.letterSpacingPercent else { return 0 }
            return (percent / 100.0) * basePt
        }()

        let resolved = ReeceFontResolver.resolve(for: spec, family: family, basePointSize: basePt)

        let base = content
            .font(resolved.font)
            .kerning(kernPoints)
            .lineSpacing(lineSpacing)
            .foregroundStyle(color ?? .primary)

        // Return per-branch to keep 'some View' types consistent
        return Group {
            if resolved.needsViewItalic {
                base.italic()
            } else {
                base
            }
        }
    }
}

public extension View {
    /// Fallback API when you already have a Text value.
    func reeceText(_ token: ReeceTextStyleToken,
                   slant: ReeceFontSlant? = nil,
                   color: Color? = nil,
                   family: ReeceFontFamily = .system,
                   designScale: CGFloat? = nil) -> some View {
        modifier(ReeceTextModifier(token: token,
                                   slant: slant,
                                   color: color,
                                   family: family,
                                   designScale: designScale))
    }
}

#if DEBUG
struct ReeceTypography_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Group {
                    Text("h1B").reeceText(.h1B)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("h1M italic").reeceText(.h1B, slant: .italic)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("h1R").reeceText(.h1R)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Group {
                    Text("h2B").reeceText(.h1B)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("h2M italic").reeceText(.h1B, slant: .italic)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("h2R").reeceText(.h1R)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Group {
                    Text("h3B").reeceText(.h1B)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("h3M italic").reeceText(.h1B, slant: .italic)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("h3R").reeceText(.h1R)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Group {
                    Text("h4B").reeceText(.h1B)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("h4M italic").reeceText(.h1B, slant: .italic)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("h4R").reeceText(.h1R)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Group {
                    Text("h5B").reeceText(.h1B)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("h5M italic").reeceText(.h1B, slant: .italic)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("h5R").reeceText(.h1R)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Group {
                    Text("Body").reeceText(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Body (Italic)").reeceText(.body, slant: .italic)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Caption").reeceText(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Group {
                    Button(action: { }) {
                        Text("Button M").reeceText(.buttonM)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Button(action: { }) {
                        Text("Button S").reeceText(.buttonS)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Group {
                    Text("Code sample: let x = 42").reeceText(.code)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
