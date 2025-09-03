//
//  ReeceFontRegister.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 03/09/25.
//
//  Registers packaged fonts at runtime (iOS + macOS) from Bundle.module/Resources/Fonts.
//

import Foundation
import CoreText

public enum ReeceFontRegister {
    /// Registers all .ttf / .otf files under Resources/Fonts (recursively).
    /// Safe to call multiple times.
    @discardableResult
    public static func registerAllFonts() -> Int {
        guard let fontsRoot = Bundle.module.url(forResource: "Fonts", withExtension: nil) else {
            #if DEBUG
            print("ReeceFontRegistrar: Fonts directory not found in Bundle.module")
            #endif
            return 0
        }

        var registeredCount = 0
        let exts = Set(["ttf","otf"])

        let fm = FileManager.default
        let enumerator = fm.enumerator(at: fontsRoot, includingPropertiesForKeys: nil)
        while let item = enumerator?.nextObject() as? URL {
            guard exts.contains(item.pathExtension.lowercased()) else { continue }

            var cfError: Unmanaged<CFError>?
            let ok = CTFontManagerRegisterFontsForURL(item as CFURL, .process, &cfError)
            if ok {
                registeredCount += 1
            } else if let e = cfError?.takeRetainedValue() {
                // If already registered, CoreText returns kCTFontManagerErrorAlreadyRegistered
                #if DEBUG
                let code = CFErrorGetCode(e)
                let domain = CFErrorGetDomain(e) as String
                let desc = CFErrorCopyDescription(e) as String
                print("ReeceFontRegistrar: Failed to register \(item.lastPathComponent) (\(domain):\(code)) – \(desc)")
                #endif
            }
        }
        #if DEBUG
        print("ReeceFontRegistrar: registered \(registeredCount) font file(s)")
        #endif
        return registeredCount
    }
}
