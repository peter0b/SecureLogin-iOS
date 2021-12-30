//
//  UIFontExtensions.swift
//  Driver
//
//  Created by Peter Bassem on 27/12/2020.
//  Copyright © 2020 Eslam Maged. All rights reserved.
//

import UIKit

// MARK: - English Fonts
@objc enum EnglishFonts: Int {
    case roboto
}

// MARK: - Arabic Fonts
@objc enum ArabicFonts: Int {
    case roboto
}

@objc enum RobotoFonts: Int {
    case black
    case blackItalic
    case bold
    case boldItalic
    case italic
    case light
    case lightItalic
    case medium
    case mediumItalic
    case regular
    case thin
    case thinItalic
    
    func name() -> String {
        switch self {
        case .black: return "Roboto-Black"
        case .blackItalic: return "Roboto-BlackItalic"
        case .bold: return "Roboto-Bold"
        case .boldItalic: return "Roboto-BoldItalic"
        case .italic: return "Roboto-Italic"
        case .light: return "Roboto-Light"
        case .lightItalic: return "Roboto-LightItalic"
        case .medium: return "Roboto-Medium"
        case .mediumItalic: return "Roboto-MediumItalic"
        case .regular: return "Roboto-Regular"
        case .thin: return "Roboto-Thin"
        case .thinItalic: return "Roboto-ThinItalic"
        }
    }
}

enum EnglishFontFamily: String {
    case robotoBlack = "Roboto-Black"
    case robotoBlackItalic = "Roboto-BlackItalic"
    case robotoBold = "Roboto-Bold"
    case robotoBoldItalic = "Roboto-BoldItalic"
    case robotoItalic = "Roboto-Italic"
    case robotoLight = "Roboto-Light"
    case robotoLightItalic = "Roboto-LightItalic"
    case robotoMedium = "Roboto-Medium"
    case robotoMediumItalic = "Roboto-MediumItalic"
    case robotoRegular = "Roboto-Regular"
    case robotoThin = "Roboto-Thin"
    case robotoThinItalic = "Roboto-ThinItalic"
}

enum ArabicFontFamily: String {
    case robotoBlack = "Roboto-Black"
    case robotoBlackItalic = "Roboto-BlackItalic"
    case robotoBold = "Roboto-Bold"
    case robotoBoldItalic = "Roboto-BoldItalic"
    case robotoItalic = "Roboto-Italic"
    case robotoLight = "Roboto-Light"
    case robotoLightItalic = "Roboto-LightItalic"
    case robotoMedium = "Roboto-Medium"
    case robotoMediumItalic = "Roboto-MediumItalic"
    case robotoRegular = "Roboto-Regular"
    case robotoThin = "Roboto-Thin"
    case robotoThinItalic = "Roboto-ThinItalic"
}

extension UIFont {
    
    static func printAllFonts() {
        let familyNames = UIFont.familyNames
        for family in familyNames {
            print("Family name " + family)
            let fontNames = UIFont.fontNames(forFamilyName: family)
            for font in fontNames {
                print("    Font name: " + font)
            }
        }
    }
    
    static func appFont(ofSize size: CGFloat, englishFontFamily: EnglishFontFamily, arabicFontFamily: ArabicFontFamily) -> UIFont {
        var fontName: String?
        if LocalizationHelper.isArabic() {
            // select from arabic fonts
            fontName = arabicFontFamily.rawValue
        } else {
            // select from english fonts
            fontName = englishFontFamily.rawValue
        }
        return UIFont(name: fontName ?? "", size: size)!
    }
}
