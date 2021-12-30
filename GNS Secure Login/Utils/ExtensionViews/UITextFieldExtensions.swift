//
//  UITextFieldExtensions.swift
//  Driver
//
//  Created by Peter Bassem on 26/12/2020.
//  Copyright © 2020 Eslam Maged. All rights reserved.
//

import UIKit

extension UITextField {
    @IBInspectable
    var isLocalized: Bool {
        get {
            return false
        } set {
            if newValue == true {
                if LocalizationHelper.isArabic() {
                    textAlignment = .right
                    makeTextWritingDirectionRightToLeft(self)
                    contentHorizontalAlignment = .right
                } else {
                    textAlignment = .left
                    makeTextWritingDirectionLeftToRight(self)
                    contentHorizontalAlignment = .left
                }
            }
        }
    }

    @IBInspectable var localizationKey: String {
        set {
            placeholder = newValue.localized()
        }
        get {
            return placeholder!
        }
    }

    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: newValue ?? .clear])
        }
    }
}

extension UITextField {
    
    func addPickerView(_ pickerView: UIPickerView) {
        inputView = pickerView
    }
}

// MARK: - Side Paddings
@IBDesignable
extension UITextField {
    
    @IBInspectable var paddingLeftCustom: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var paddingRightCustom: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
}

extension UITextField {
    
    func setLeftPadding(padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPadding(padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

// MARK: - Show or hide password
extension UITextField {
    
    func showOrHidePassword() {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(DesignSystem.Icon.visibilityOff.image.imageWithColor(color: DesignSystem.Colors.primary.color), for: .normal)
        button.setImage(DesignSystem.Icon.visibilityOn.image.imageWithColor(color: DesignSystem.Colors.primary.color), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.frame = CGRect(x: (frame.size.width - 25), y: CGFloat(5), width: CGFloat(15), height: CGFloat(25))
        button.isSelected = true
        button.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        rightView = button
        rightViewMode = .whileEditing
    }
    
    @objc func onClick(_ sender: UIButton) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        sender.isSelected = !sender.isSelected
    }
    
    func addImageToRight(_ image: UIImage, color: UIColor = .black, renderingMode: UIImage.RenderingMode = .alwaysOriginal) {
        let imageView = UIImageView(image: image.withRenderingMode(renderingMode))
        imageView.tintColor = color
        imageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        imageContainerView.addSubview(imageView)
        rightView = imageContainerView
    }
    
    func addImageToLeft(_ image: UIImage, color: UIColor = .black, renderingMode: UIImage.RenderingMode = .alwaysOriginal, padding: CGFloat = 0.0) {
        let imageView = UIImageView(image: image.withRenderingMode(renderingMode))
        imageView.tintColor = color
        imageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: padding, width: 55, height: 40))
        imageContainerView.addSubview(imageView)
        leftView = imageContainerView
        leftViewMode = .always
    }
}

// MARK: - Fonts
extension UITextField {
    
    private static var englishFontType: EnglishFonts = .roboto
    private var englishFontType: EnglishFonts {
        get { return .roboto }
        set { UITextField.englishFontType = newValue }
    }
    private static var englishFontSize: CGFloat = 17
    
    private static var arabicFontType: ArabicFonts = .roboto
    private var arabicFontType: ArabicFonts {
        get { return .roboto }
        set { UITextField.arabicFontType = newValue }
    }
    
    // MARK: -
    @IBInspectable
    var englishFontSize: CGFloat {
        get { return font?.pointSize ?? 17.0 }
        set {
            if !LocalizationHelper.isArabic() {
                UITextField.englishFontSize = newValue
                switch UITextField.englishFontType {
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
            switch UITextField.englishFontType {
            case .roboto:
                font = UIFont(name: RobotoFonts(rawValue: newValue)?.name() ?? "", size: UITextField.englishFontSize)
            }
        }
    }
    
//    // MARK: -
    @IBInspectable
    var arabicFontSize: CGFloat {
        get { return font?.pointSize ?? 17.0 }
        set {
            if LocalizationHelper.isArabic() {
                switch UITextField.arabicFontType {
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
                switch UITextField.arabicFontType {
                case .roboto:
                    font = UIFont(name: RobotoFonts(rawValue: newValue)?.name() ?? "", size: arabicFontSize)
                
                }
            }
        }
    }
}

// MARK: - UIDatePickerView
extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        }
        inputView = datePickerView
        datePickerView.addTarget(target, action: selector, for: .valueChanged)
    }
}

// MARK: - UIPickerView
extension UITextField {
    
    func setInputViewPicker(_ picker: UIPickerView) {
        inputView = picker
    }
}
