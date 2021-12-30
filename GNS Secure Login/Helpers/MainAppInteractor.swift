//
//  MainAppInteractor.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 21/12/2021.
//

import Foundation
import UIKit

class MainAppInteractor {
    
    private static var mWindow: UIWindow!
    
    static func setRoot(_ window: UIWindow? = nil) -> UIWindow? {
        if let window = window {
            self.mWindow = window
        }
        let splitViewController = SplitViewController()
        splitViewController.viewControllers = [
            UINavigationController(rootViewController: HomeRouter.createModule()),
            UINavigationController(rootViewController: ScanBadgeRouter.createModule())
        ]
        mWindow.rootViewController = splitViewController
//        let homeVC = UINavigationController(rootViewController: HomeRouter.createModule())
//        window.rootViewController = homeVC
        mWindow.makeKeyAndVisible()
        return mWindow
    }
}
