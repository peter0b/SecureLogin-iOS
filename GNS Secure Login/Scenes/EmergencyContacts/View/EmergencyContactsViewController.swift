//
//  EmergencyContactsViewController.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 25/07/2021.
//

import UIKit

final class EmergencyContactsViewController: BaseViewController {
    
    // MARK: - Outlets
    
    // MARK: - Variables
    var presenter: EmergencyContactsPresenterProtocol!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
    }
}
