//
//  PhoneNumberTextField.swift
//  MandoBee
//
//  Created by Peter Bassem on 27/07/2021.
//

import UIKit
#if canImport(FlagPhoneNumber)
//import FlagPhoneNumber

protocol PhoneNumberTextFieldDelegate: AnyObject {
    func phoneNumberTextFieldIsValidPhone(_ isValid: Bool)
    func phoneNumberTextFieldDisplayCountriesListViewController()
}

class PhoneNumberTextField: FPNTextField {
    
    // MARK: - Variables
    private static var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    private(set) var isPhoneValid: Bool = false
    
    weak var phoneNumberDelegate: PhoneNumberTextFieldDelegate?
    
    // MARK: - IBInspectable
    @IBInspectable var showPhoneExample: Bool = true

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    // MARK: - Private Configuration
    private func configure() {
        displayMode = .list
        flagButtonSize = .init(width: 40, height: 40)
        flagButton.imageEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 10)
        hasPhoneNumberExample = showPhoneExample
        textColor = DesignSystem.Colors.textPrimary.color
        placeHolderColor = DesignSystem.Colors.textPlaceholder.color
        setFlag(countryCode: .EG)
        setCountries(including: [.EG])
        delegate = self
    }
    
    static func createListCountriesNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: listController)
    }
}

extension PhoneNumberTextField: FPNTextFieldDelegate {
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) { }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        isPhoneValid = isValid
        phoneNumberDelegate?.phoneNumberTextFieldIsValidPhone(isValid)
        let validationImage = isValid ? DesignSystem.Icon.success.image : DesignSystem.Icon.error.image
        let imageView = UIImageView(image: validationImage)
        imageView.contentMode = .center
        rightViewMode = .whileEditing
        rightView = imageView
    }
    
    func fpnDisplayCountryList() {
        phoneNumberDelegate?.phoneNumberTextFieldDisplayCountriesListViewController()
    }
}
#endif
