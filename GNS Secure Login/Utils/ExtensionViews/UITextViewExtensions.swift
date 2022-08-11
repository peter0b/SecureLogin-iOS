//
//  UITextViewExtensions.swift
//  incadre
//
//  Created by Peter Bassem on 15/02/2021.
//  Copyright © 2021 Boo Doo. All rights reserved.
//

import UIKit

// MARK: - Fonts
extension UITextView {
    
    private static var englishFontType: EnglishFonts = .roboto
    private var englishFontType: EnglishFonts {
        get { return .roboto }
        set { UITextView.englishFontType = newValue }
    }
    private static var englishFontSize: CGFloat = 17
    
    private static var arabicFontType: ArabicFonts = .roboto
    private var arabicFontType: ArabicFonts {
        get { return .roboto }
        set { UITextView.arabicFontType = newValue }
    }
    
    // MARK: -
    @IBInspectable
    var englishFontSize: CGFloat {
        get { return font?.pointSize ?? 17.0 }
        set {
            if !LocalizationHelper.isArabic() {
                UITextView.englishFontSize = newValue
                switch UITextView.englishFontType {
                case .roboto: font = UIFont(name: RobotoFonts(rawValue: englishSubFontRow)?.name() ?? "", size: newValue)
                }
            }
        }
    }
    
    @IBInspectable
    var englishFontRow: Int {
        get { return 0 }
        set {
            englishFontType = EnglishFonts(rawValue: newValue) ?? .roboto
        }
    }
    
    @IBInspectable
    var englishSubFontRow: Int {
        get { return 0 }
        set {
            switch UITextView.englishFontType {
            case .roboto:
                font = UIFont(name: RobotoFonts(rawValue: newValue)?.name() ?? "", size: UITextView.englishFontSize)
            }
        }
    }
    
//    // MARK: -
    @IBInspectable
    var arabicFontSize: CGFloat {
        get { return font?.pointSize ?? 17.0 }
        set {
            if LocalizationHelper.isArabic() {
                switch UITextView.arabicFontType {
                case .roboto:
                    font = UIFont(name: RobotoFonts(rawValue: arabicSubFontRow)?.name() ?? "", size: newValue)
                }
            }
        }
    }

    @IBInspectable
    var arabicFontRaw: Int {
        get { return 0 }
        set { arabicFontType = ArabicFonts(rawValue: newValue) ?? .roboto }
    }

    @IBInspectable
    var arabicSubFontRow: Int {
        get { return 0 }
        set {
            if LocalizationHelper.isArabic() {
                switch UITextView.arabicFontType {
                case .roboto:
                    font = UIFont(name: RobotoFonts(rawValue: newValue)?.name() ?? "", size: arabicFontSize)
                
                }
            }
        }
    }
}
