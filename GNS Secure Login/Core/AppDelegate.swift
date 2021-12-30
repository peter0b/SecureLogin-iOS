//
//  AppDelegate.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 20/07/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseHelpers.configureFirebase()
//        setupWindow()
        if #available(iOS 13.0, *) { } else {
            self.window = MainAppInteractor.setRoot(UIWindow(frame: UIScreen.main.bounds))
        }
        setupIQKeyboard()
        return true
    }
    
    private func setupWindow() {
        if #available(iOS 13.0, *) { return } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            let splitViewController = SplitViewController()
            splitViewController.viewControllers = [
                UINavigationController(rootViewController: HomeRouter.createModule()),
                UINavigationController(rootViewController: ScanBadgeRouter.createModule())
            ]
            window.rootViewController = splitViewController // UINavigationController(rootViewController: AuthRouter.createModule())
            window.makeKeyAndVisible()
            self.window = window
        }
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate {
    
    func setRoot() {
        
    }
}
