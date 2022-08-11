//
//  UIViewControllerExtensions.swift
//  Driver
//
//  Created by Peter Bassem on 26/12/2020.
//  Copyright © 2020 Eslam Maged. All rights reserved.
//

import UIKit

// MARK: - Alerts
extension UIViewController {
    
    func showMessage(title: String, message: String) {
        let messageAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "ok", comment: ""), style: UIAlertAction.Style.default, handler: nil)
        messageAlert.addAction(okButton)
        present(messageAlert, animated: true, completion: nil)
    }
    
    func showMessageWithCompletionHandler(title: String, message: String, onCompletion completion: @escaping () -> Void) {
        let messageAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "ok", comment: ""), style: UIAlertAction.Style.default) { (_) in
            completion()
        }
        messageAlert.addAction(okButton)
        present(messageAlert, animated: true, completion: nil)
    }
    
    func showMessageWithTwoButtonsWithCompletionHandler(title: String, message: String, onOkCompletion okCompletion: @escaping () -> Void, onCancelCompletion cancelCompletion: @escaping () -> Void) {
        let messageAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "ok", comment: ""), style: UIAlertAction.Style.default) { (_) in
            okCompletion()
        }
        let cancelButton = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancel", comment: ""), style: UIAlertAction.Style.destructive) { (_) in
            cancelCompletion()
        }
        messageAlert.addAction(okButton)
        messageAlert.addAction(cancelButton)
        present(messageAlert, animated: true, completion: nil)
    }
}

// MARK: - Navigation Bar
extension UIViewController {
    
    func setNavigationBarItems(titleKey: String, barTintColor: UIColor = .white, tintColor: UIColor = .black) {
        navigationItem.title = titleKey.localized()
        navigationController?.navigationBar.barTintColor =  barTintColor
        self.navigationController?.navigationBar.tintColor = tintColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: DesignSystem.Typography.display2.font, NSAttributedString.Key.foregroundColor: tintColor]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: tintColor]
        navigationController?.navigationBar.isTranslucent = false
    }
}

// MARK: - Activity Indicators in UIViewControllers
extension UIViewController {
    
    func setupActivityIndicator(_ activityIndicator: UIActivityIndicatorView) {
        if #available(iOS 13.0, *) {
            activityIndicator.style = UIActivityIndicatorView.Style.large
        } else {
            activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        }
        activityIndicator.color = .white
        activityIndicator.isHidden = false
    }
    
    func startActivityIndicator(_ activityIndicator: UIActivityIndicatorView) {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator(_ activityIndicator: UIActivityIndicatorView) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    static var progressView: NVActivityIndicatorView?
    
    func NVActivityIndicator(isActive active: Bool) {
        if active {
            UIViewController.progressView = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x - 30, y: self.view.center.y - 30, width: 60, height: 60), type: .ballRotateChase, color: .white, padding: 0)
            let mask = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            mask.backgroundColor = UIColor.lightGray
            UIViewController.progressView?.mask = mask
            self.view.addSubview(UIViewController.progressView!)
            self.view.resignFirstResponder()
            UIViewController.progressView?.startAnimating()
            self.view.isUserInteractionEnabled = false
        } else {
            if UIViewController.progressView != nil {
                UIViewController.progressView?.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
}

// MARK: - UIViewController Instantiation
extension UIViewController {
    
    class func instantiateViewController(viewControllerId: ViewControllerID, storyboardId: StoryboardID) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardId.rawValue, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: viewControllerId.rawValue)
        return controller
    }
}

// MARK: - Navigate to Settings
extension UIViewController {
    
    func goToLanguageSettings() {
        let alertController = UIAlertController(title: "Title", message: "Go to Settings?", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: "App-Prefs:root=Privacy&path=PREFERRED_LANGUAGE") else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { success in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func goToSettings(completion: (() -> Void)?) {
        let alertController = UIAlertController(title: "location_denied_title".localized(), message: "app_settings".localized(), preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "settings".localized(), style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { _ in
                    completion?()
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "cancel".localized(), style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Child Controllers
extension UIViewController {
    
    func embed(_ viewController: UIViewController, inParent controller: UIViewController, inView view: UIView) {
        self.view.layoutIfNeeded()
        viewController.willMove(toParent: controller)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        controller.addChild(viewController)
        viewController.didMove(toParent: controller)
    }

    func embed(_ viewControllers: [UIViewController], inParent controller: UIViewController, inView view: UIView) {
        self.view.layoutIfNeeded()
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: CGFloat(viewControllers.count) * view.bounds.width)
        ])
        self.view.layoutIfNeeded()
        for (index, viewController) in viewControllers.enumerated() {
            viewController.willMove(toParent: controller)
            let width = view.bounds.width / 2
            viewController.view.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: view.bounds.height)
            view.addSubview(viewController.view)
            controller.addChild(viewController)
            viewController.didMove(toParent: controller)
            viewController.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        }
        self.view.layoutIfNeeded()
    }
}

// MARK: - Set Root Controller
extension UIViewController {
    
    func setRoot(storyboardID: StoryboardID, viewControllerID: ViewControllerID, animated: Bool) {
        guard let window = keyWindow else {
            return
        }
        let storyboard = UIStoryboard(name: storyboardID.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: viewControllerID.rawValue)
        window.rootViewController = vc
        if animated {
            let options: UIView.AnimationOptions = [.transitionCrossDissolve, .allowUserInteraction]
            let duration: TimeInterval = 0.3
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: { _ in
                // maybe do something on completion here
            })
        }
    }

    func setRoot(ViewController vc: UIViewController, animated: Bool) {
        guard let window = keyWindow else {
            return
        }
        window.rootViewController = vc
        if animated {
            let options: UIView.AnimationOptions = [.transitionCrossDissolve, .allowUserInteraction]
            let duration: TimeInterval = 0.3
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: { _ in
                // maybe do something on completion here
            })
        }
    }
}

// MARK: - Navigation Between Controllers
extension UIViewController {
    
    func presentFullScreen(ViewController vc: UIViewController, animated: Bool) {
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    func presentOverCurrentContext(viewController vc: UIViewController, animated: Bool) {
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
    }

    func pushFullScreen(ViewController vc: UIViewController, animated: Bool) {
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Navigation Item Image
extension UIViewController {
    
    func navigationItemTitleImage(image: UIImage) {
        let titleViewImage = UIImageView(image: image)
        titleViewImage.frame = CGRect(x: 0, y: 0, width: 128, height: 38)
        titleViewImage.contentMode = .scaleAspectFit
        navigationItem.titleView = titleViewImage
    }

    func navigationbarBackButton() {
        let backImage = UIImage(named: "navigate_back")?.withRenderingMode(.alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationController?.navigationItem.backBarButtonItem?.title = ""
        navigationController?.viewControllers.last?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

// MARK: - Create loder view
private let spinnerTag = 101010101014510
extension UIViewController {
    func showSpinner(onView: UIView, backColor: UIColor = UIColor.black.withAlphaComponent(0)) {
        let spinnerView = UIView(frame: onView.bounds)
        spinnerView.backgroundColor = backColor
        //
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        blurEffectView.cornerRadius = 10
        blurEffectView.clipsToBounds = true
        blurEffectView.center = spinnerView.center
        spinnerView.addSubview(blurEffectView)
        //
        var ai = UIActivityIndicatorView()
        if #available(iOS 13, *) {
            ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        } else {
            ai = UIActivityIndicatorView(style: .whiteLarge)
        }
        ai.color = .white
        ai.startAnimating()
        ai.center = spinnerView.center

        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }

        spinnerView.tag = spinnerTag
    }

    func removeSpinner(fromView: UIView) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            var loader: UIView? = fromView.viewWithTag(spinnerTag)
            UIView.animate(withDuration: 0.2, animations: {
                loader?.alpha = 0
            }, completion: { _ in
                loader?.removeFromSuperview()
                loader = nil
            })
        }
    }
}

// MARK: - Toast
extension UIViewController {
    
    func showToast(message: String) {
//        var window: UIWindow
//        if #available(iOS 13.0, *) {
//            guard let gWindow = UIApplication.shared.connectedScenes
//                .filter({$0.activationState == .foregroundActive})
//                .map({$0 as? UIWindowScene})
//                .compactMap({$0})
//                .first?.windows
//                .filter({$0.isKeyWindow}).first else { return }
//            window = gWindow
//        } else {
//            guard let gWindow = UIApplication.shared.keyWindow else { return }
//            window = gWindow
//        }
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.font = DesignSystem.Typography.paragraphSmall.font
        toastLabel.textColor = .white
        toastLabel.backgroundColor = .black
        toastLabel.numberOfLines = 0
        
        let textSize = toastLabel.intrinsicContentSize
        let labelHeight = (textSize.width / keyWindow!.frame.width) * 30
        let labelWidth = min(textSize.width, keyWindow!.frame.width - 40)
        let height = max(labelHeight, textSize.height + 20)
        toastLabel.frame = .init(x: 20, y: (keyWindow!.frame.height - 90) - height, width: labelWidth + 20, height: height)
        toastLabel.center.x = keyWindow!.center.x
        toastLabel.cornerRadius = 10
        toastLabel.layer.masksToBounds = true
        keyWindow?.addSubview(toastLabel)
        
        UIView.animate(withDuration: 3.0) {
            toastLabel.alpha = 0
        } completion: { _ in
            toastLabel.removeFromSuperview()
        }
    }
}

// MARK: - SplashScreen Animation
extension UIViewController {
    
    func splashAnimation(iconImage: UIImage, backgroundImage: UIImage) {
        let splashView = SplashView(iconImage: iconImage, iconInitialSize: .init(width: (view.frame.size.width), height: (view.frame.size.width)), backgroundImage: backgroundImage)
        self.view.addSubview(splashView)
        
        splashView.duration = 5.0
        splashView.animationType = AnimationType.twitter
        splashView.iconColor = UIColor.red
        splashView.useCustomIconColor = false
        splashView.startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            splashView.finishHeartBeatAnimation()
        }
    }
}

// MARK: - StatusBar Height
extension UIViewController {
    
     func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
}

// MARK: - Toast
extension UIViewController {
    
    func showToastMessage(message: String) {
        ToastManager.shared.showError(message: message, view: view, completion: nil)
    }
}
