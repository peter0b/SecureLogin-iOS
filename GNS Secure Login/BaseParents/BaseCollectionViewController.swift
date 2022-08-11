//
//  BaseCollectionViewController.swift
//  E-Council
//
//  Created by Peter Bassem on 9/13/20.
//  Copyright © 2020 Peter Bassem. All rights reserved.
//

import UIKit

class BaseCollectionViewController: UICollectionViewController {
    
    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension BaseCollectionViewController: BaseViewProtocol {
    
    @objc func showLoading() {
//        ActivityIndicatorManager.shared.showProgressView()
        view.isUserInteractionEnabled = false
        showSpinner(onView: view)
    }
    
    @objc func hideLoading() {
//        ActivityIndicatorManager.shared.hideProgressView()
        view.isUserInteractionEnabled = true
        removeSpinner(fromView: view)
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
        ToastManager.shared.showError(message: message, view: self.view, completion: nil)
    }
    
    func showBottomMessage(_ message: String) {
        TTGSnackbarHelper.showSnackBar(inView: self.view, wihthLocationInView: .bottom, withMessage: message) { (_) in }
    }
}
