//
//  BaseViewController.swift
//  Aman Elshark
//
//  Created by Peter Bassem on 1/12/20.
//  Copyright © 2020 Peter Bassem. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, NVActivityIndicatorViewable {
    
    // MARK: - Properties
    
    // MARK: - Init
    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BaseViewController: BaseViewProtocol {
    
    func showLoading() {
        view.subviews.forEach { $0.alpha = 0 }
        keyWindow?.startBlockingActivityIndicator()
    }
    
    func hideLoading() {
        view.subviews.forEach { $0.alpha = 1 }
        keyWindow?.stopBlockingActivityIndicator()
    }
    
    func showErrorAlert(error: String) {
        AlertView.AlertViewBuilder().setTitle(with: LocalizationSystem.sharedInstance.localizedStringForKey(key: "error", comment: ""))
            .setMessage(with: error)
            .setAlertType(with: .failure)
            .setButtonTitle(with: LocalizationSystem.sharedInstance.localizedStringForKey(key: "done", comment: ""))
            .build()
        return
    }
    
    func showErrorMessage(message: String) {
        ToastManager.shared.showError(message: message, view: view, completion: nil)
    }
    
    func showBottomMessage(_ message: String) {
        TTGSnackbarHelper.showSnackBar(inView: self.view, wihthLocationInView: .bottom, withMessage: message) { (_) in }
    }
}
