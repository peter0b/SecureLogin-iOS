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
}
