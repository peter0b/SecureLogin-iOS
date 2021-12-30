//
//  ActivityIndicator.swift
//  ElNabawy Cars
//
//  Created by Peter Bassem on 6/12/19.
//  Copyright © 2019 Peter Bassem. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicatorManager  {
    static let shared = ActivityIndicatorManager()
    
    private var containerView: UIView = {
        let view = UIView()
        view.frame = UIWindow(frame: UIScreen.main.bounds).frame
        view.center = UIWindow(frame: UIScreen.main.bounds).center
        view.backgroundColor = UIColor(rgbValue: 0xffffff, alpha: 0.3)
        return view
    }()
    
    private var progressView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        view.center = UIWindow(frame: UIScreen.main.bounds).center
        view.backgroundColor = UIColor(rgbValue: 0x444444, alpha: 0.7)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        activityIndicator.color = .white
        activityIndicator.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    func showProgressView() {
        progressView.addSubview(activityIndicator)
        containerView.addSubview(progressView)
        keyWindow?.addSubview(containerView)
    }
    
    func hideProgressView() {
        activityIndicator.stopAnimating()
        containerView.removeFromSuperview()
    }
}
