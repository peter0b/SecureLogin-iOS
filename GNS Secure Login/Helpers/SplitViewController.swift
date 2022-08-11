//
//  SplitViewController.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 25/07/2021.
//

import UIKit

class SplitViewController: UISplitViewController {
    
    private var firstLaunch = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        self.delegate = self
//        self.preferredDisplayMode = .allVisible
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.preferredDisplayMode = .allVisible
        } else {
            self.preferredDisplayMode = .allVisible
        }
    }
}

// MARK: - UISplitViewControllerDelegate
extension SplitViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        if firstLaunch {
            firstLaunch = false
            return true
        }
        return false
    }
}
