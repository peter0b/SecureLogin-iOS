//
//  EditApplicationCredentialsViewController.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 27/12/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit
import CoreBluetooth
import SmartCardIO

final class EditApplicationCredentialsViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet private weak var applicationImageView: UIImageView!
    @IBOutlet private weak var usernameTextField: UITextField! {
        didSet { usernameTextField.addTarget(self, action: #selector(textFieldValueDidChanged(_:)), for: .editingChanged) }
    }
    @IBOutlet private weak var passwordTextField: PasswordTextField! {
        didSet { passwordTextField.addTarget(self, action: #selector(textFieldValueDidChanged(_:)), for: .editingChanged) }
    }
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: - Variables
	var presenter: EditApplicationCredentialsPresenterProtocol!
    
    var _applicationImageView: UIImageView {
        return applicationImageView
    }
    var _saveButton: UIButton {
        return saveButton
    }
    
    var card: Card
    var mifareDesfireHelper: MiFareDesfireHelper!
    
    init(card: Card, mifareDesfireHelper: MiFareDesfireHelper) {
        self.card = card
        self.mifareDesfireHelper = mifareDesfireHelper
        super.init()
    }
    
    required init?(coder: NSCoder) {
        let bluetoothManager = BluetoothManager.getInstance()
        let cardChannel = bluetoothManager.getChardChannel()
        card = cardChannel!.card
        mifareDesfireHelper = MiFareDesfireHelper(card: card, mifareNFCCardManager: ApduCommandExecuter())
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
        presenter.performValidate(username: usernameTextField.text, password: passwordTextField.text)
    }
}

// MARK: - Helpers
extension EditApplicationCredentialsViewController {
    
}

// MARK: - Selectors
extension EditApplicationCredentialsViewController {
    
    @IBAction
    private func backButtonDidPressed(_ sender: UIButton) {
        presenter.performBack()
    }
    
    @objc
    private func textFieldValueDidChanged(_ sender: UITextField) {
        presenter.performValidate(username: usernameTextField.text, password: passwordTextField.text)
    }
    
    @IBAction
    private func saveButtonDidPressed(_ sender: UIButton) {
        presenter.performSave(username: usernameTextField.text, password: passwordTextField.text)
    }
}
