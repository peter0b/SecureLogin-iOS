//
//  BaseView.swift
//  FlyWashClub
//
//  Created by Peter Bassem on 1/18/20.
//  Copyright © 2020 Peter Bassem. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
//    func setup(_ imageView: UIImageView, image: UIImage?, imageContentMode: UIView.ContentMode?, languageKey: String?) {
//        imageView.contentMode = imageContentMode ?? UIView.ContentMode.scaleAspectFit
//        guard let language = languageKey else {
//            imageView.image = image
//            return
//        }
//        switch language {
//        case Language.english.description: imageView.image = image
//        case Language.arabic.description: imageView.image = image?.withHorizontallyFlippedOrientation()
//        default: ()
//        }
//    }
//    
//    func setup(_ label: UILabel, textKey: String, textColor: UIColor?, textAlignment: NSTextAlignment?, fontSize: CGFloat, bold: Bool, attributedString: NSAttributedString?, languageKey: String?) {
//        label.attributedText = attributedString
//        label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: textKey, comment: "")
//        label.textColor = textColor ?? .black
//        label.font = setFont(size: fontSize, isBold: bold)
//        if let languageKey = languageKey {
//            switch languageKey {
//            case Language.english.description: label.textAlignment = .left
//            case Language.arabic.description: label.textAlignment = .right
//            default: ()
//            }
//        } else {
//            label.textAlignment = textAlignment ?? .left
//        }
//    }
//    
//    func setup(_ label: UILabel, textKey: String, textColor: UIColor?, textAlignment: NSTextAlignment?, fontSize: CGFloat, bold: Bool, attributedString: NSAttributedString?) {
//       label.attributedText = attributedString
//       label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: textKey, comment: "")
//       label.textColor = textColor ?? .black
//       label.textAlignment = textAlignment ?? .left
//       label.font = setFont(size: fontSize, isBold: bold)
//   }
//    
//    func setup(_ textField: UITextField, textKey: String, textColor: UIColor?, fontSize: CGFloat, bold: Bool, keyboardType: UIKeyboardType?, borderStyle: UITextField.BorderStyle?, isPassword: Bool) {
//        textField.backgroundColor = .clear
//        textField.borderStyle = borderStyle ?? .none
//        textField.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: textKey, comment: "")
//        textField.font = setFont(size: fontSize, isBold: bold)
//        textField.textColor = textColor ?? .black
//        textField.textAlignment = setLocalizedTextAlignment()
//        textField.keyboardType = keyboardType ?? .default
//        textField.isSecureTextEntry = isPassword
//    }
//    
//    func setup(_ button: UIButton, textKey: String, fontSize: CGFloat, bold: Bool, titleColor: UIColor?) {
//        button.backgroundColor = .mainColor //COLORS.mainColor
//        button.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: textKey, comment: ""), for: UIControl.State.normal)
//        button.setTitleColor(titleColor ?? .white, for: UIControl.State.normal)
//        button.titleLabel?.font = setFont(size: fontSize, isBold: bold)
//        button.layer.cornerRadius = button.frame.height / 2
//    }
//    
//    func setup(_ view: UIView) {
//        view.backgroundColor = .mainColor //COLORS.mainColor
//    }
}
