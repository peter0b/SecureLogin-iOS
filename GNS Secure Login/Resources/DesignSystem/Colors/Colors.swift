//
//  Colors.swift
//  MandoBee
//
//  Created by Peter Bassem on 17/06/2021.
//

import Foundation
import UIKit

extension DesignSystem {
    
    enum Colors: String {
        case primary = "Primary"
        case background = "Background"
        case backgroundSecondary = "BackgroundSecondary"
        case background4 = "Background4"
        case background5 = "Background5"
        case backgroundTransparentColor = "BackgroundTransparentColor"
        case primaryGradient = "PrimaryGradient"
        case secondaryGradient = "SecondaryGradient"
        case textPrimary = "TextPrimary"
        case text3 = "Text3"
        case textDescription = "TextDescription"
        case textPlaceholder = "TextPlaceholder"
        case primaryActionText = "PrimaryActionText"
        case secondaryActionText = "SecondaryActionText"
        case primaryActionBackground = "PrimaryActionBackground"
        case backgroundPrimary = "BackgroundPrimary"
        case placeholderPrimary = "PlaceholderPrimary"
        
        var color: UIColor {
            return UIColor(named: self.rawValue)!
        }
    }
}
