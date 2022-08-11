//
//  EnrollmentAlertViewController.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 10/08/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

final class EnrollmentAlertViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet private weak var alertTitleLabel: UILabel!
    @IBOutlet private weak var alertTextField: UITextField! {
        didSet {alertTextField.addTarget(self, action: #selector(alertTextFieldTextDidChanged(_:)), for: .editingChanged) }
    }
    @IBOutlet private weak var submitButton: UIButton!
    
    // MARK: - Variables
	var presenter: EnrollmentAlertPresenterProtocol!
    
    var _alertTitleLabel: UILabel {
        return alertTitleLabel
    }
    var _alertTextField: UITextField {
        return alertTextField
    }
    var _submitButton: UIButton {
        return submitButton
    }

    // MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
        presenter.performValidateCode(alertTextField.text)
        alertTextField.becomeFirstResponder()
    }
}

// MARK: - Helpers
extension EnrollmentAlertViewController {
    
}

// MARK: - Selectors
extension EnrollmentAlertViewController {
    @objc
    private func alertTextFieldTextDidChanged(_ sender: UITextField) {
        presenter.performValidateCode(alertTextField.text)
    }
    
    @IBAction
    private func cancelButtonDidPressed(_ sender: UIButton) {
        presenter.performCancel()
    }

    
    @IBAction
    private func submitButtonDidPressed(_ sender: UIButton) {
        presenter.perfromSubmit(alertTextField.text)
    }
}
