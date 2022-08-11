//
//  UIButtonExtensions.swift
//  Driver
//
//  Created by Peter Bassem on 27/12/2020.
//  Copyright © 2020 Eslam Maged. All rights reserved.
//

import UIKit

extension UIButton {
    
    func configureButton(_ enable: Bool) {
        isEnabled = enable
        alpha = enable ? 1 : 0.5
    }
}

// MARK: -
@IBDesignable
extension UIButton {
    @IBInspectable var localizationKey: String {
        set {
            setTitle(newValue.localized(), for: .normal)
        }
        get {
            return (titleLabel?.text)!
        }
    }
    
    @IBInspectable var flipRightToLeft: Bool {
        set {
            if LocalizationHelper.isArabic() == true && newValue == true {
                let rotatedImage = image(for: .normal)?.flippedImageToRight()
                setImage(rotatedImage, for: .normal)
            }
        }
        get {
            return self.flipRightToLeft
        }
    }
}

// MARK: - Add Side Images
extension UIButton {
    
    func leftImage(image: UIImage, renderMode: UIImage.RenderingMode) {
        if UIDevice.modelName.contains("5") {
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.width/7, bottom: 0, right: self.frame.width/7)
        } else {
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.width/4, bottom: 0, right: self.frame.width/4)
        }
        self.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        self.setImage(image.withRenderingMode(renderMode), for: UIControl.State.normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: image.size.width / 2)
        self.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
    }
    
    func rightImage(image: UIImage, renderMode: UIImage.RenderingMode) {
        if UIDevice.modelName.contains("5") {
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.width/8, bottom: 0, right: self.frame.width/8)
        } else {
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.width/5, bottom: 0, right: self.frame.width/5)
        }
        self.setImage(image.withRenderingMode(renderMode), for: UIControl.State.normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: image.size.width / 2, bottom: 0, right: 16)
        self.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        self.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
    }
}

extension UIButton {
    
    func setupButtonWithImage(englishTitleEdgeInsets: UIEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0), arbabicTitleEdgeInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)) {
        if LocalizationHelper.getCurrentLanguage() == LanguageConstants.englishLanguage.rawValue {
            semanticContentAttribute = .forceLeftToRight
            self.titleEdgeInsets = englishTitleEdgeInsets
        } else {
            semanticContentAttribute = .forceRightToLeft
            self.titleEdgeInsets = arbabicTitleEdgeInsets
        }
    }
    
    func setupReversedButtonWithImage(englishTitleEdgeInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10), arbabicTitleEdgeInsets: UIEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)) {
        if LocalizationHelper.getCurrentLanguage() == LanguageConstants.englishLanguage.rawValue {
            semanticContentAttribute = .forceRightToLeft
            self.titleEdgeInsets = englishTitleEdgeInsets
        } else {
            semanticContentAttribute = .forceLeftToRight
            self.titleEdgeInsets = arbabicTitleEdgeInsets
        }
    }
    
    func makeMultiLineSupport() {
        guard let titleLabel = titleLabel else {
            return
        }
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        addConstraints([
            .init(item: titleLabel,
                  attribute: .top,
                  relatedBy: .greaterThanOrEqual,
                  toItem: self,
                  attribute: .top,
                  multiplier: 1.0,
                  constant: contentEdgeInsets.top),
            .init(item: titleLabel,
                  attribute: .bottom,
                  relatedBy: .greaterThanOrEqual,
                  toItem: self,
                  attribute: .bottom,
                  multiplier: 1.0,
                  constant: contentEdgeInsets.bottom),
            .init(item: titleLabel,
                  attribute: .left,
                  relatedBy: .greaterThanOrEqual,
                  toItem: self,
                  attribute: .left,
                  multiplier: 1.0,
                  constant: contentEdgeInsets.left),
            .init(item: titleLabel,
                  attribute: .right,
                  relatedBy: .greaterThanOrEqual,
                  toItem: self,
                  attribute: .right,
                  multiplier: 1.0,
                  constant: contentEdgeInsets.right)
        ])
    }
}

// MARK: - Add Gradient Colors
extension UIButton {
    
    /**
     Adds background gradient color to UIButton.
     */
    func applyBackgroundGradient(_ color1: CGColor = UIColor.lightGray.cgColor, _ color2: CGColor = UIColor.darkGray.cgColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [color1, color2]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.cornerRadius = (frame.height / 2)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

// MARK: - Add Activity Indicator To Button
private var originalButtonText: String?
private var activityIndicator: UIActivityIndicatorView!

extension UIButton {
    
    private static var loadingText: String?
    
    @IBInspectable var indicatorColor: UIColor {
        get { return .white }
        set {
            activityIndicator = createActivityIndicator()
            activityIndicator.color = newValue
        }
    }
    @IBInspectable var loadingText: String {
        get { return "" }
        set { UIButton.loadingText = newValue }
    }
    
    func showLoading() {
        originalButtonText = self.titleLabel?.text
        self.setTitle(UIButton.loadingText?.localized(), for: .normal)
        
        if activityIndicator == nil {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }
    
    func hideLoading() {
        self.setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = indicatorColor
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        if UIButton.loadingText != nil && UIButton.loadingText != "" {
            activityIndicator.trailingAnchor.constraint(equalTo: titleLabel!.leadingAnchor, constant: -15).isActive = true
        } else {
            let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
            self.addConstraint(xCenterConstraint)
        }
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}

// MARK: - Fonts
extension UIButton {
    
    private static var englishFontType: EnglishFonts = .roboto
    private var englishFontType: EnglishFonts {
        get { return .roboto }
        set { UIButton.englishFontType = newValue }
    }
    private static var englishFontSize: CGFloat = 17
    
    private static var arabicFontType: ArabicFonts = .roboto
    private var arabicFontType: ArabicFonts {
        get { return .roboto }
        set { UIButton.arabicFontType = newValue }
    }
    
    // MARK: -
    @IBInspectable
    var englishFontSize: CGFloat {
        get { return titleLabel?.font.pointSize ?? 17.0  }
        set {
            if !LocalizationHelper.isArabic() {
                UIButton.englishFontSize = newValue
                switch UIButton.englishFontType {
                case .roboto: titleLabel?.font = UIFont(name: RobotoFonts(rawValue: englishSubFontRow)?.name() ?? "", size: newValue)
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
            switch UIButton.englishFontType {
            case .roboto:
                titleLabel?.font = UIFont(name: RobotoFonts(rawValue: newValue)?.name() ?? "", size: UIButton.englishFontSize)
            }
        }
    }
    
//    // MARK: -
    @IBInspectable
    var arabicFontSize: CGFloat {
        get { return titleLabel?.font.pointSize ?? 17.0 }
        set {
            if LocalizationHelper.isArabic() {
                switch UIButton.arabicFontType {
                case .roboto: titleLabel?.font = UIFont(name: RobotoFonts(rawValue: arabicSubFontRow)?.name() ?? "", size: newValue)
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
                switch UIButton.arabicFontType {
                case .roboto:
                    titleLabel?.font = UIFont(name: RobotoFonts(rawValue: newValue)?.name() ?? "", size: arabicFontSize)
                }
            }
        }
    }
}

// MARK: - AlignableButton Extension
extension UIButton {
    
    func setupButton(image: UIImage, selectedImage: UIImage, title: String, titleColor: UIColor = .black, titleFont: UIFont = DesignSystem.Typography.paragraphSmall.font) {
        setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .selected)
        localizationKey = title
        setTitleColor(titleColor, for: .normal)
        setTitleColor(DesignSystem.Colors.primary.color, for: .selected)
        titleLabel?.font = titleFont
    }
}
