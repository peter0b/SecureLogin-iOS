//
//  DesignableTextField.swift
//  Baby Cart
//
//  Created by Peter Bassem on 5/14/20.
//  Copyright © 2020 Peter Bassem. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableUITextField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()
//        tintColor = color
    }
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leadingPadding
        return textRect
    }
   
    // Provides right padding for images
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= leadingPadding
        return textRect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if LocalizationHelper.getCurrentLanguage() == LanguageConstants.englishLanguage.rawValue {
            return bounds.inset(by: .init(top: topInset, left: (leftInset + leadingPadding), bottom: bottomInset, right: (rightInset + 10)))
        } else {
            return bounds.inset(by: .init(top: topInset, left: (rightInset + 10), bottom: bottomInset, right: (leftInset + leadingPadding)))
        }
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        if LocalizationHelper.getCurrentLanguage() == LanguageConstants.englishLanguage.rawValue {
            return bounds.inset(by: .init(top: topInset, left: (leftInset + leadingPadding), bottom: bottomInset, right: (rightInset + 10)))
        } else {
            return bounds.inset(by: .init(top: topInset, left: (rightInset + 10), bottom: bottomInset, right: (leftInset + leadingPadding)))
        }
    }
   
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 20
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    
    @IBInspectable var leadingImage: UIImage? {
        didSet {
            updateView()
        }
    }
   
    @IBInspectable var leadingPadding: CGFloat = 0
   
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
   
    @IBInspectable var rtl: Bool = false {
        didSet {
            updateView()
        }
    }
   
    func updateView() {
        rightViewMode = UITextField.ViewMode.never
        rightView = nil
        leftViewMode = UITextField.ViewMode.never
        leftView = nil
       
        if let image = leadingImage {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
           
            if rtl {
                rightViewMode = UITextField.ViewMode.always
                rightView = imageView
            } else {
                leftViewMode = UITextField.ViewMode.always
                leftView = imageView
            }
        }
       
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}
