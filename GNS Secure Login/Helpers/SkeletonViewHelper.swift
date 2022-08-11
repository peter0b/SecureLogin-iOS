//
//  UIView+Shimmer.swift
//  Dars
//
//  Created by Peter Bassem on 11/18/20.
//  Copyright © 2020 Peter Bassem. All rights reserved.
//

import UIKit
import SkeletonView

extension UIView {
    
    func showShimmerEffect(gradientDirection: GradientDirection = .topLeftBottomRight, primaryColor: UIColor = DesignSystem.Colors.primaryGradient.color, secondaryColor: UIColor = DesignSystem.Colors.secondaryGradient.color) {
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: gradientDirection)
        SkeletonAppearance.default.gradient = .init(baseColor: primaryColor, secondaryColor: secondaryColor)
        showAnimatedGradientSkeleton(animation: animation)
    }
    
    func hideShimmerEffect() {
        hideSkeleton()
    }
}
