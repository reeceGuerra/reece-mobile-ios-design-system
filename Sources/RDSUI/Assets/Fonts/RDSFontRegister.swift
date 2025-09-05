//
//  RDSFontRegister.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 03/09/25.
//
//  Registers packaged fonts at runtime (iOS + macOS) from Bundle.module/Resources/Fonts.
//

import Foundation
import CoreText

public enum RDSFontRegister {
    /// Registers all .ttf / .otf files under Resources/Fonts (recursively).
    /// Safe to call multiple times.
    @discardableResult
        public static func registerAllFonts() -> Int {
            guard let root = Bundle.module.resourceURL else {
                #if DEBUG
                print("RDSFontRegistrar: resourceURL is nil for Bundle.module")
                #endif
                return 0
            }

            let exts = Set(["ttf","otf"])
            var registered = 0

            if let enumerator = FileManager.default.enumerator(
                at: root, includingPropertiesForKeys: [.isRegularFileKey]
            ) {
                for case let url as URL in enumerator {
                    guard exts.contains(url.pathExtension.lowercased()) else { continue }

                    var cfError: Unmanaged<CFError>?
                    let ok = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &cfError)
                    if ok {
                        registered += 1
                    } else if let e = cfError?.takeRetainedValue() {
                        #if DEBUG
                        // Already-registered isn’t fatal; CoreText returns a specific error code.
                        let code = CFErrorGetCode(e)
                        let domain = CFErrorGetDomain(e) as String
                        let desc = CFErrorCopyDescription(e) as String
                        print("RDSFontRegistrar: could not register \(url.lastPathComponent) (\(domain):\(code)) – \(desc)")
                        #endif
                    }
                }
            }

            #if DEBUG
            print("RDSFontRegistrar: registered \(registered) font file(s)")
            #endif
            return registered
        }
}
