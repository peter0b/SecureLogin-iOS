//
//  UITabBarExtensions.swift
//  Driver
//
//  Created by Peter Bassem on 26/12/2020.
//  Copyright © 2020 Eslam Maged. All rights reserved.
//

import UIKit

extension UITabBar {
    
    func addGradientColor(withColors colors : [UIColor]) {
        let gradientlayer = CAGradientLayer()
        gradientlayer.frame = bounds
        gradientlayer.colors = colors
        gradientlayer.locations = [0, 1]
        gradientlayer.startPoint = CGPoint(x: 0, y: 0)
        gradientlayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientlayer, at: 0)
    }
}
