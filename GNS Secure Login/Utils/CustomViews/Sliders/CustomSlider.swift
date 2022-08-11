//
//  CustomSlider.swift
//  incadre
//
//  Created by Peter Bassem on 22/02/2021.
//  Copyright © 2021 Boo Doo. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSlider: UISlider {

@IBInspectable var trackHeight: CGFloat = 6

override func trackRect(forBounds bounds: CGRect) -> CGRect {
    var rect = super.trackRect(forBounds: bounds)
    rect.size.height = trackHeight
    rect.origin.y -= trackHeight / 2
    return rect
  }
}
