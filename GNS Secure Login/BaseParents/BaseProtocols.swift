//
//  BaseProtocols.swift
//  Aman Elshark
//
//  Created by Peter Bassem on 1/12/20.
//  Copyright © 2020 Peter Bassem. All rights reserved.
//

import Foundation
import UIKit

protocol BaseViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showErrorAlert(error: String)
    func showErrorMessage(message: String)
    func showBottomMessage(_ message: String)
}

protocol BasePresenterProtocol: AnyObject {
    func showErrorAlert(error: String)
}

protocol BaseRouterProtocol {
    func popupViewController()
    func popoupToSplitRootViewViewController()
    func dismissViewController()
    func presentImagePickerViewController(completion: @escaping (UIImage) -> Void)
}

protocol BaseInteractorInputProtocol: AnyObject {
    
}

protocol BaseInteractorOutputProtocol: AnyObject {
    
}
