//
//  BaseRouter.swift
//  MandoBee
//
//  Created by Peter Bassem on 06/07/2021.
//

import Foundation
import UIKit

class BaseRouter: BaseRouterProtocol {
    
    weak var viewController: UIViewController?
    private var actionController: UIAlertController!
    
    func popupViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func popoupToSplitRootViewViewController() {
        viewController?.splitViewController?.navigationController?.popViewController(animated: true)
    }
    
    func dismissViewController() {
        viewController?.dismiss(animated: true)
    }
    
    func presentImagePickerViewController(completion: @escaping (UIImage) -> Void) {
        guard let viewController = viewController else { return }
        ImagePickerManager().pickImage(viewController) { image, _ in
            completion(image)
        }
    }
    
    func presentAlertControl(title: String?, message: String?, actionTitle: String?, action: (() -> Void)?) {
        actionController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            action?()
        }
        actionController.addAction(action)
        viewController?.present(actionController, animated: true)
    }
}
