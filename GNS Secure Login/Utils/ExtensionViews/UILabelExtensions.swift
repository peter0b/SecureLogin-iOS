//
//  UILabelExtensions.swift
//  Driver
//
//  Created by Peter Bassem on 27/12/2020.
//  Copyright © 2020 Eslam Maged. All rights reserved.
//

import UIKit

extension UILabel {
    @IBInspectable var localizationKey: String {
        set {
            text = newValue.localized()
        }
        get {
            return text!
        }
    }
}

// MARK: - Fonts
extension UILabel {
    
    private static var englishFontSize: CGFloat = 17
    private static var englishFontType: EnglishFonts = .roboto
    private static var englishSubFontRow: Int = 0
    private var englishFontType: EnglishFonts {
        get { return .roboto }
        set { UILabel.englishFontType = newValue }
    }
    
    private static var arabicFontType: ArabicFonts = .roboto
    private var arabicFontType: ArabicFonts {
        get { return .roboto }
        set { UILabel.arabicFontType = newValue }
    }
    private static var arabicFontSize: CGFloat = 17
    
    // MARK: -
    @IBInspectable
    var englishFontSize: CGFloat {
        get { return font.pointSize }
        set {
            if !LocalizationHelper.isArabic() {
                UILabel.englishFontSize = newValue
                switch UILabel.englishFontType {
                case .roboto:
                    font = UIFont(name: RobotoFonts(rawValue: UILabel.englishSubFontRow)?.name() ?? "", size: newValue)
                }
            }
        }
    }
    
    @IBInspectable
    var englishFontRow: Int {
        get { return 0 }
        set {
            englishFontType = EnglishFonts(rawValue: newValue) ?? .roboto
            UILabel.englishFontType = EnglishFonts(rawValue: newValue) ?? .roboto
        }
    }
    
    @IBInspectable
    var englishSubFontRow: Int {
        get { return 0 }
        set {
            UILabel.englishSubFontRow = newValue
            switch UILabel.englishFontType {
            case .roboto:
                font = UIFont(name: RobotoFonts(rawValue: newValue)?.name() ?? "", size: UILabel.englishFontSize)
            }
        }
    }
    
    // MARK: -
    @IBInspectable
    var arabicFontSize: CGFloat {
        get { return font.pointSize }
        set {
            if LocalizationHelper.isArabic() {
                switch UILabel.arabicFontType {
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
                switch UILabel.arabicFontType {
                case .roboto:
                    font = UIFont(name: RobotoFonts(rawValue: newValue)?.name() ?? "", size: arabicFontSize)
                }
            }
        }
    }
}

// MARK: - Change Spacing between multilines
extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment

        let attrString = NSMutableAttributedString()
        if self.attributedText != nil {
            attrString.append( self.attributedText!)
        } else {
            attrString.append( NSMutableAttributedString(string: self.text!))
            attrString.addAttribute(NSAttributedString.Key.font, value: self.font ?? UIFont.systemFont(ofSize: 12), range: NSMakeRange(0, attrString.length))
        }
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}
