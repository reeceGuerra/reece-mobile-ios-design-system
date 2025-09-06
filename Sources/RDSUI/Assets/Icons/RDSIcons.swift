//
//  RDSIcons.swift
//  RDSUI
//
//  Created by Carlos Lopez on 06/09/25.
//

import SwiftUI

// MARK: - RDSIcon

/// A strongly typed representation of all icons available in the design system.
/// This enum avoids the use of raw string names when accessing icons.
public enum RDSIcon: String, CaseIterable {
    // MARK: Actions
    case add
    case delete
    case download
    case edit
    case search
    case share
    
    // MARK: Media
    case camera1 = "camera-1"
    case gallery
    case microphone1 = "microphone-1"
    case phone1 = "phone-1"
    
    // MARK: Commerce
    case shoppingCart = "shopping-cart"
    case creditCardVisa = "credit-card-visa"
    case creditCardMastercard = "credit-card-mastercard"
    case creditCardAmex = "credit-card-amex"
}

/// Public API for creating SwiftUI Images using design system icons.
public extension Image {
    /// Creates an Image from a design system icon.
    ///
    /// - Parameter rds: The `RDSIcon` case representing the desired icon.
    /// - Returns: A SwiftUI `Image` configured to use the design system bundle.
    init(rds: RDSIcon) {
        self.init(rds.rawValue, bundle: .rdsBundle)
    }
}
