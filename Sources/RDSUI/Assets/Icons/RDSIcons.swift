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
    
    // MARK: Location
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
