//
//  BaseTableViewController.swift
//  Dars
//
//  Created by Peter Bassem on 11/8/20.
//  Copyright © 2020 Peter Bassem. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

}

extension BaseTableViewController: BaseViewProtocol {
    
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
