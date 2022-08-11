//
//  DesignableImageTextField.swift
//  MandoBee
//
//  Created by Peter Bassem on 07/07/2021.
//

import UIKit

protocol DesignableImageTextFieldDelegate: UITextFieldDelegate {
    func textFieldIconClicked(_ button: UIButton)
}

@IBDesignable
class DesignableImageTextField: UITextField {
    
    // MARK: - IBInspectable
    @IBInspectable var padding: CGFloat = 0
    @IBInspectable var leadingImage: UIImage? { didSet { updateView() } }
    @IBInspectable var imageColor: UIColor = .clear { didSet { updateView() } }
    @IBInspectable var rtl: Bool = false { didSet { updateView() } }
    
    // MARK: - Variables
    //Delegate when image/icon is tapped.
    private var myDelegate: DesignableImageTextFieldDelegate? {
        get { return delegate as? DesignableImageTextFieldDelegate }
    }
    
    
    // MARK: - Paddings
    // Padding images on left
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        if LocalizationHelper.isArabic() {
            textRect.origin.x += padding
        }
        return textRect
    }
    
    // Padding images on Right
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        if !LocalizationHelper.isArabic() {
            textRect.origin.x -= padding
        }
        return textRect
    }
    
    // MARK: - Configuration
    private func updateView() {
        rightViewMode = UITextField.ViewMode.never
        rightView = nil
        leftViewMode = UITextField.ViewMode.never
        leftView = nil
        
        if let image = leadingImage {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            
            let tintedImage = image.withRenderingMode(.alwaysTemplate)
            button.setImage(tintedImage, for: .normal)
            button.tintColor = imageColor
            
            button.setTitleColor(UIColor.clear, for: .normal)
            button.addTarget(self, action: #selector(buttonClicked(_:)), for: UIControl.Event.touchDown)
            button.isUserInteractionEnabled = true
            
            if rtl {
                rightViewMode = UITextField.ViewMode.always
                rightView = button
            } else {
                leftViewMode = UITextField.ViewMode.always
                leftView = button
            }
        }
    }
}

// MARK: - Selector
extension DesignableImageTextField {
    
    @objc
    private func buttonClicked(_ sender: UIButton) {
        self.myDelegate?.textFieldIconClicked(sender)
    }
}
