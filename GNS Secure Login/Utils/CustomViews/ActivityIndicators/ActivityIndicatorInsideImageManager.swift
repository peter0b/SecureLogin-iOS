//
//  ActivityIndicatorInsideImageManager.swift
//  ElNabawy Cars
//
//  Created by Peter Bassem on 6/18/19.
//  Copyright © 2019 Peter Bassem. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicatorInsideImageManager {
    static let shared = ActivityIndicatorInsideImageManager()
    
    private var progressView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        view.center = UIWindow(frame: UIScreen.main.bounds).center
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if #available(iOS 13.0, *) {
            activityIndicator.style = UIActivityIndicatorView.Style.large
        } else {
            activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        }
        activityIndicator.color = .gray
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    func showIndicator(_ imageView: UIImageView) {
        progressView.addSubview(activityIndicator)
        imageView.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
            ])
        activityIndicator.startAnimating()
    }
    
    func hideIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}
