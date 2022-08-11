//
//  EnrollmentAlertViewController+Delegates.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 10/08/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

extension EnrollmentAlertViewController: EnrollmentAlertViewProtocol {
    func setAlertTitle(_ title: String) {
        _alertTitleLabel.text = title
    }
    
    func setAlertTextFieldPlaceholder(_ placeholder: String) {
        _alertTextField.placeholder = placeholder
    }
    
    func disableSubmitButton() {
        _submitButton.configureButton(false)
    }
    
    func enableSubmitButton() {
        _submitButton.configureButton(true)
    }
}
