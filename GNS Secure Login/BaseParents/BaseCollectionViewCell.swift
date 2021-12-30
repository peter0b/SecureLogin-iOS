//
//  BaseCollectionViewCell.swift
//  Aman Elshark
//
//  Created by Peter Bassem on 1/16/20.
//  Copyright © 2020 Peter Bassem. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    func setup(_ imageView: UIImageView, image: UIImage?, imageContentMode: UIView.ContentMode?, languageKey: String?) {
//        imageView.contentMode = imageContentMode ?? UIView.ContentMode.scaleAspectFit
//        guard let language = languageKey else {
//            imageView.image = image
//            return
//        }
//        
//        LocalizationHelper.isArabic() ? imageView.image = image?.withHorizontallyFlippedOrientation() : imageView.image = image
//    }
//    
//    func setup(_ label: UILabel, textKey: String, textColor: UIColor?, textAlignment: NSTextAlignment?, fontSize: CGFloat, eFont: EnglishFonts?, bold: Bool, attributedString: NSAttributedString?, languageKey: String?) {
//        label.attributedText = attributedString
//        label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: textKey, comment: "")
//        label.textColor = textColor ?? .black
//        label.font = UIFont.appFont(ofSize: fontSize, englishFontFamily: .SFRegular, arabicFontFamily: .CairoRegular)
//        if let languageKey = languageKey {
//            LocalizationHelper.isArabic() ? label.textAlignment = .right : label.textAlignment = .left
//        } else {
//            label.textAlignment = textAlignment ?? .left
//        }
//    }
//    
//    //    func setup(_ label: UILabel, textKey: String, textColor: UIColor?, textAlignment: NSTextAlignment?, fontSize: CGFloat, bold: Bool, attributedString: NSAttributedString?) {
//    //        label.attributedText = attributedString
//    //        label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: textKey, comment: "")
//    //        label.textColor = textColor ?? .black
//    //        label.textAlignment = textAlignment ?? .left
//    //        label.font = setFont(size: fontSize, isBold: bold)
//    //    }
//    
//    func setup(_ textField: UITextField, textKey: String, textColor: UIColor?, fontSize: CGFloat, bold: Bool, eFont: EnglishFonts?, keyboardType: UIKeyboardType?, borderStyle: UITextField.BorderStyle?, isPassword: Bool) {
//            textField.backgroundColor = .clear
//            textField.borderStyle = borderStyle ?? .none
//    //        textField.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: textKey, comment: "")
//            textField.attributedPlaceholder = NSAttributedString(string: LocalizationSystem.sharedInstance.localizedStringForKey(key: textKey, comment: ""), attributes: [NSAttributedString.Key.foregroundColor: textColor ?? UIColor.black])
//        textField.font = UIFont.appFont(ofSize: fontSize, englishFontFamily: .SFRegular, arabicFontFamily: .CairoRegular)
//    //        textField.textColor = textColor ?? .black
//            textField.textAlignment = setLocalizedTextAlignment()
//            textField.keyboardType = keyboardType ?? .default
//            textField.isSecureTextEntry = isPassword
//        }
//    
//    func setup(_ button: UIButton, textKey: String, fontSize: CGFloat, bold: Bool, eFont: EnglishFonts?, titleColor: UIColor?, backgroundColor: UIColor? = .clear, cornerRadius: CGFloat?) {
//        button.backgroundColor = backgroundColor
//        button.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: textKey, comment: ""), for: UIControl.State.normal)
//        button.setTitleColor(titleColor ?? .white, for: UIControl.State.normal)
//        button.titleLabel?.font = setFont(size: fontSize, isBold: bold, englishFont: eFont)
//        if let cornerRadius = cornerRadius {
//            button.layer.cornerRadius = cornerRadius
//        } else {
//            button.layer.cornerRadius = button.frame.height / 2
//        }
//    }
//    
//    func setup(_ button: UIBarButtonItem, image: UIImage?, titleKey: String?, titleColor: UIColor? = .white, fontSize: CGFloat, bold: Bool) {
//        button.setTitleTextAttributes([NSAttributedString.Key.font: setFont(size: 17.0, isBold: false), NSMutableAttributedString.Key.foregroundColor: titleColor ?? .white], for: .normal)
//        if let image = image {
//            button.image = image
//        } else if let titleKey = titleKey {
//            button.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: titleKey, comment: "")
//        }
//    }
//    
//    func setup(_ button: UIButton, textKey: String, fontSize: CGFloat, bold: Bool, titleColor: UIColor?, backgroundColor: UIColor? = .white, cornerRadius: CGFloat?, image: UIImage?, imageColor: UIColor?, languageKey: String?) {
//        button.backgroundColor = backgroundColor
//        button.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: textKey, comment: ""), for: UIControl.State.normal)
//        button.setTitleColor(titleColor ?? .white, for: UIControl.State.normal)
//        button.titleLabel?.font = setFont(size: fontSize, isBold: bold)
//        if let cornerRadius = cornerRadius {
//            button.layer.cornerRadius = cornerRadius
//        }
//        guard let image = image, let imageColor = imageColor else { return }
//        switch languageKey {
//        case Language.english.description:
//            button.setBackgroundImage(image.imageWithColor(color: imageColor), for: .normal)
//        case Language.arabic.description:
//            button.setBackgroundImage(image.imageWithColor(color: imageColor).withHorizontallyFlippedOrientation(), for: .normal)
//        default: ()
//        }
//    }
//    
//    //    func setup(_ button: UIButton, textKey: String, fontSize: CGFloat, bold: Bool, titleColor: UIColor?) {
//    //        button.backgroundColor = COLORS.mainColor
//    //        button.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: textKey, comment: ""), for: UIControl.State.normal)
//    //        button.setTitleColor(titleColor ?? .white, for: UIControl.State.normal)
//    //        button.titleLabel?.font = setFont(size: fontSize, isBold: bold)
//    //        button.layer.cornerRadius = button.frame.height / 2
//    //    }
//    
//    func setup(_ view: UIView) {
//        view.backgroundColor = .mainColor //COLORS.mainColor
//    }
//    
//    func validateInputs(textFields: [UITextField], errorMessages: [String]) -> (Bool, String?) {
//        for (index, textField) in textFields.enumerated() {
//            if !textField.hasText || textField.text?.count ?? 0 <= 0 {
//                return (false, errorMessages[index])
//            }
//        }
//        return (true, nil)
//    }
}

extension BaseCollectionViewCell: BaseViewProtocol {
    
    func showLoading() {
        ActivityIndicatorManager.shared.showProgressView()
    }
    
    func hideLoading() {
        ActivityIndicatorManager.shared.hideProgressView()
    }
    
    func showErrorAlert(error: String) {
        AlertView.AlertViewBuilder().setTitle(with: LocalizationSystem.sharedInstance.localizedStringForKey(key: "error", comment: ""))
            .setMessage(with: error)
            .setAlertType(with: .failure)
            .setButtonTitle(with: LocalizationSystem.sharedInstance.localizedStringForKey(key: "done", comment: ""))
            .build()
    }
    
    func showErrorMessage(message: String) {
        ToastManager.shared.showError(message: message, view: self, completion: nil)
    }
    
    func showBottomMessage(_ message: String) {
        
    }
}
