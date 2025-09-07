//
//  RDSIcons.swift
//  RDSUI
//
//  Created by Carlos Lopez on 06/09/25.
//

import SwiftUI

// MARK: - RDSIconCategory

/// High-level buckets used to organize design-system icons for discovery,
/// menus, and documentation.
public enum RDSIconCategory: String, CaseIterable {
    case actions
    case commerce
    case files
    case places     // formerly "location" to avoid name collision with the `location` icon
    case media
    case misc
    case navigation
    case system
    case time
    case user
}

// MARK: - RDSIcon

/// A strongly typed representation of all icons available in the design system.
/// This enum avoids the use of raw string names when accessing icons.
/// Icons are grouped by category for clarity.
public enum RDSIcon: String, CaseIterable {
    
    // MARK: Actions
    case add
    case clear
    case delete
    case deleteBin = "delete-bin"
    case download
    case edit
    case expand
    case fileUpload = "file-upload"
    case filterAlt = "filter-alt"
    case hide
    case minus
    case orderApprove = "order-approve"
    case plus
    case print
    case queue
    case quickOrder = "quick-order"
    case refresh
    case saveCart = "save-cart"
    case savePdf = "save-pdf"
    case scan
    case search
    case send
    case share
    case show
    
    // MARK: Commerce
    case creditCardAmex = "credit-card-amex"
    case creditCardApplePay = "credit-card-applepay"
    case creditCardDiscover = "credit-card-discover"
    case creditCardGooglePay = "credit-card-googlepay"
    case creditCardMastercard = "credit-card-mastercard"
    case creditCardOther = "credit-card-other"
    case creditCardOutline = "credit-card-outline"
    case creditCardVisa = "credit-card-visa"
    case delivery
    case invoice
    case miscCharge = "misc-charge"
    case mfrCatalog = "mfr-catalog"
    case payment
    case shoppingCart = "shopping-cart"
    case technicalSpecs = "technical-specs"
    
    // MARK: Files
    case nimbusInvoice = "nimbus-invoice"
    case quote
    
    // MARK: Places (was Location)
    case liveLocationDeny1 = "live-location-deny-1"
    case liveLocationDeny2 = "live-location-deny-2"
    case liveLocationFocused = "live-location-focused"
    case liveLocationUnfocused1 = "live-location-unfocused-1"
    case liveLocationUnfocused2 = "live-location-unfocused-2"
    case location
    case locationMarker1 = "location-marker-1"
    case mapPinLargeSelected = "map-pin-large-selected"
    case mapPinLargeUnselected = "map-pin-large-unselected"
    case mapPinSmallUnselect = "map-pin-small-unselect"
    
    // MARK: Media
    case camera1 = "camera-1"
    case flash
    case gallery
    case microphone1 = "microphone-1"
    case phone1 = "phone-1"
    
    // MARK: Misc
    case bookmark
    case box
    case branch
    case browse
    case calendar
    case checkmark
    case checkmarkCircle = "checkmark-circle"
    case company
    case dashboard
    case ellipsis
    case globe
    case home
    case inStock = "in-stock"
    case starEmpty = "star-empty"
    case starFilled = "star-filled"
    case union
    
    // MARK: Navigation
    case arrowLeft = "arrow-left"
    case arrowRight = "arrow-right"
    case chevronLeft = "chevron-left"
    case chevronRight = "chevron-right"
    case chevronUp = "chevron-up"
    case menu
    case sort
    case sortDown = "sort-down"
    case sortUp = "sort-up"
    
    // MARK: System
    case accountSettings = "account-settings"
    case help
    case info
    case notifications
    case security
    case settings
    case supportChat = "support-chat"
    case warning
    
    // MARK: Time
    case clock
    case history
    
    // MARK: User
    case email
    case keyboard
    case login
    case myList = "my-list"
    case myOrders = "my-orders"
}

// MARK: - Categorization

public extension RDSIcon {
    /// Returns the high-level category for the current icon.
    ///
    /// - Returns: An ``RDSIconCategory`` grouping used in galleries, pickers, and docs.
    var category: RDSIconCategory {
        switch self {
        // Actions
        case .add, .clear, .delete, .deleteBin, .download, .edit, .expand,
             .fileUpload, .filterAlt, .hide, .minus, .orderApprove, .plus,
             .print, .queue, .quickOrder, .refresh, .saveCart, .savePdf,
             .scan, .search, .send, .share, .show:
            return .actions

        // Commerce
        case .creditCardAmex, .creditCardApplePay, .creditCardDiscover,
             .creditCardGooglePay, .creditCardMastercard, .creditCardOther,
             .creditCardOutline, .creditCardVisa, .delivery, .invoice,
             .miscCharge, .mfrCatalog, .payment, .shoppingCart, .technicalSpecs:
            return .commerce

        // Files
        case .nimbusInvoice, .quote:
            return .files

        // Places (formerly Location)
        case .liveLocationDeny1, .liveLocationDeny2, .liveLocationFocused,
             .liveLocationUnfocused1, .liveLocationUnfocused2, .location,
             .locationMarker1, .mapPinLargeSelected, .mapPinLargeUnselected,
             .mapPinSmallUnselect:
            return .places

        // Media
        case .camera1, .flash, .gallery, .microphone1, .phone1:
            return .media

        // Misc
        case .bookmark, .box, .branch, .browse, .calendar, .checkmark,
             .checkmarkCircle, .company, .dashboard, .ellipsis, .globe, .home,
             .inStock, .starEmpty, .starFilled, .union:
            return .misc

        // Navigation
        case .arrowLeft, .arrowRight, .chevronLeft, .chevronRight, .chevronUp,
             .menu, .sort, .sortDown, .sortUp:
            return .navigation

        // System
        case .accountSettings, .help, .info, .notifications, .security,
             .settings, .supportChat, .warning:
            return .system

        // Time
        case .clock, .history:
            return .time

        // User
        case .email, .keyboard, .login, .myList, .myOrders:
            return .user
        }
    }

    /// Returns all icons grouped by the given category.
    ///
    /// - Parameter category: The ``RDSIconCategory`` to filter by.
    /// - Returns: An array of icons belonging to the category.
    static func icons(in category: RDSIconCategory) -> [RDSIcon] {
        allCases.filter { $0.category == category }
    }

    /// Convenience collection: all Actions icons.
    static var actions: [RDSIcon] { icons(in: .actions) }

    /// Convenience collection: all Commerce icons.
    static var commerce: [RDSIcon] { icons(in: .commerce) }

    /// Convenience collection: all File-related icons.
    static var files: [RDSIcon] { icons(in: .files) }

    /// Convenience collection: all Places (maps/location) icons.
    static var places: [RDSIcon] { icons(in: .places) }

    /// Convenience collection: all Media icons.
    static var media: [RDSIcon] { icons(in: .media) }

    /// Convenience collection: miscellaneous icons.
    static var misc: [RDSIcon] { icons(in: .misc) }

    /// Convenience collection: all Navigation icons.
    static var navigation: [RDSIcon] { icons(in: .navigation) }

    /// Convenience collection: all System icons.
    static var system: [RDSIcon] { icons(in: .system) }

    /// Convenience collection: all Time icons.
    static var time: [RDSIcon] { icons(in: .time) }

    /// Convenience collection: all User icons.
    static var user: [RDSIcon] { icons(in: .user) }

    /// Human-friendly label built from the raw asset name (kebab-case → Title Case).
    ///
    /// - Returns: A prettified name useful for demos and documentation.
    var displayName: String {
        rawValue
            .replacingOccurrences(of: "-", with: " ")
            .split(separator: " ")
            .map { $0.capitalized }
            .joined(separator: " ")
    }
}

// MARK: - Image extension

public extension Image {
    /// Creates a SwiftUI Image from a design system icon.
    ///
    /// - Parameter rds: The `RDSIcon` case representing the desired icon.
    /// - Returns: A SwiftUI `Image` initialized with the icon resource.
    init(rds: RDSIcon) {
        self.init(rds.rawValue, bundle: .rdsBundle)
    }
}

