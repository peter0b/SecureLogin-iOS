//
//  ReachabilityManager.swift
//  Login Location
//
//  Created by Peter Bassem on 1/8/19.
//  Copyright © 2019 Peter Bassem. All rights reserved.
//


// IN APP DELEGATE

// func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//    // Override point for customization after application launch.
// /    ReachabilityManager.shared.startMonitoring()
//    return true
// }

// func applicationWillEnterForeground(_ application: UIApplication) {
//    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
// /    ReachabilityManager.shared.stopMonitoring()
// }
//
// func applicationDidBecomeActive(_ application: UIApplication) {
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
// /    ReachabilityManager.shared.startMonitoring()
// }


import Foundation

public protocol NetworkStatusListener: AnyObject {
    func networkStatusDidChange(status: Reachability.NetworkStatus)
}

class ReachabilityManager: NSObject {
    static let shared = ReachabilityManager()
    var isNetworkAvailable: Bool {
        return reachabilityStatus != .notReachable
    }
    var reachabilityStatus: Reachability.NetworkStatus = .notReachable
    let reachability = Reachability()!
    var listeners = [NetworkStatusListener]()
    
    @objc func reachabilityChanged(notification: Notification) {
        guard let reachability = notification.object as? Reachability else { return }
        switch reachability.currentReachabilityStatus {
        case .notReachable:
            debugPrint("Network became unreachable")
        case .reachableViaWiFi:
            debugPrint("Network reachable through WiFi")
        case .reachableViaWWAN:
            debugPrint("Network reachable through Cellular Data")
        }
        for listener in listeners {
            listener.networkStatusDidChange(status: reachability.currentReachabilityStatus)
        }
    }
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: reachabilityChangedNotification, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    func stopMonitoring() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: reachabilityChangedNotification, object: reachability)
    }
    
    func addListener(listener: NetworkStatusListener) {
        listeners.append(listener)
    }
    
    func removeListener(listener: NetworkStatusListener) {
        listeners = listeners.filter { $0 !== listener }
    }
}
