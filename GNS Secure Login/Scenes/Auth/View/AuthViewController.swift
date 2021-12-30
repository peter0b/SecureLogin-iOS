//
//  AuthViewController.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 21/07/2021.
//

import UIKit

final class AuthViewController: BaseViewController {
    
    let username = "peter0b"
    let password = "1234"
    
    // MARK: - Outlets
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButtonPortraitBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var loginButtonLandscapeBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    var presenter: AuthPresenterProtocol!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Helpers
extension AuthViewController {
    
    private func setupLoginButton() {
        if UIDevice.current.orientation.isPortrait {
            // Handle Bottom Constraint for button in portrait mode for devices that has notch and older version devices
            if UIDevice.hasTopNotch {
                loginButtonPortraitBottomConstraint.constant = -5
            } else {
                loginButtonPortraitBottomConstraint.constant = -10
            }
        }
    }
}

// MARK: - Selectors
extension AuthViewController {
    
    @IBAction
    private func loginButtonDidPressed(_ sender: UIButton) {
        if usernameTextField.text == username && passwordTextField.text == password {
            let usernameCFString = (usernameTextField.text ?? "") as CFString
            let passwordCFString = (passwordTextField.text ?? "") as CFString
            SecAddSharedWebCredential(
                "las.s-badge.com" as CFString,
                usernameCFString,
                passwordCFString) { error in
                if let error = error {
                    print("Failed to save user to icloud keychain:", error)
                    return
                }
                self.presenter.performLogin()
            }
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        setupLoginButton()
    }
}
