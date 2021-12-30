//
//  AlignableButton.swift
//  Dars
//
//  Created by Peter Bassem on 10/19/20.
//  Copyright © 2020 Peter Bassem. All rights reserved.
//

import UIKit

@IBDesignable
class AlignableButton: UIButton {
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    @objc enum IconAlignment: Int {
        case top, left, right, bottom
    }
    
    // MARK: - Designables
    @IBInspectable var iconAlignmentValue: Int {
        set {
            iconAlignment = IconAlignment(rawValue: newValue) ?? .left
        }
        get {
            return iconAlignment.rawValue
        }
    }
    
    var iconAlignment: IconAlignment = .left
    
    @IBInspectable var titleAlignmentValue: Int {
        set {
            titleAlignment = NSTextAlignment(rawValue: newValue) ?? .left
        }
        get {
            return titleAlignment.rawValue
        }
    }
    
    var titleAlignment: NSTextAlignment = .left
    
    // MARK: - Corner Radius
    @IBInspectable
    override var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = (newValue != 0)
            layer.cornerRadius = newValue
        }
    }
    
    // MARK: - Content size
    override var intrinsicContentSize: CGSize {
        
        switch iconAlignment {
        case .top, .bottom:
            return verticalAlignedIntrinsicContentSize
            
        default:
            return super.intrinsicContentSize
        }
    }
    
    private var verticalAlignedIntrinsicContentSize: CGSize {
        
        if let imageSize = imageView?.intrinsicContentSize,
            let labelSize = titleLabel?.intrinsicContentSize {
            
            let width = max(imageSize.width, labelSize.width) + contentEdgeInsets.left + contentEdgeInsets.right
            let height = imageSize.height + labelSize.height + contentEdgeInsets.top + contentEdgeInsets.bottom
            
            return CGSize(
                width: ceil(width),
                height: ceil(height)
            )
        }
        
        return super.intrinsicContentSize
    }
    
    // MARK: - Image Rect
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        switch iconAlignment {
        case .top:
            return topAlignedImageRect(forContentRect: contentRect)
        case .bottom:
            return bottomAlignedImageRect(forContentRect: contentRect)
        case .left:
            return leftAlignedImageRect(forContentRect: contentRect)
        case .right:
            return rightAlignedImageRect(forContentRect: contentRect)
        }
    }
    
    func topAlignedImageRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.imageRect(forContentRect: contentRect)
        
        let x = (contentRect.width - rect.width) / 2.0 + contentRect.minX
        let y = contentRect.minY
        let w = rect.width
        let h = rect.height
        
        return CGRect(
            x: x,
            y: y,
            width: w,
            height: h
        ).inset(by: imageEdgeInsets)
    }
    
    func bottomAlignedImageRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.imageRect(forContentRect: contentRect)
        
        let x = (contentRect.width - rect.width) / 2.0 + contentRect.minX
        let y = contentRect.height - rect.height + contentRect.minY
        let w = rect.width
        let h = rect.height
        
        return CGRect(
            x: x,
            y: y,
            width: w,
            height: h
        ).inset(by: imageEdgeInsets)
    }
    
    func leftAlignedImageRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.imageRect(forContentRect: contentRect)
        
        let x = contentRect.minX
        let y = (contentRect.height - rect.height) / 2 + contentRect.minY
        let w = rect.width
        let h = rect.height
        
        return CGRect(
            x: x,
            y: y,
            width: w,
            height: h
        ).inset(by: imageEdgeInsets)
    }
    
    func rightAlignedImageRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.imageRect(forContentRect: contentRect)
        
        let x = (contentRect.width - rect.width) + contentRect.minX
        let y = (contentRect.height - rect.height) / 2 + contentRect.minY
        let w = rect.width
        let h = rect.height
        
        return CGRect(
            x: x,
            y: y,
            width: w,
            height: h
        ).inset(by: imageEdgeInsets)
    }
    
    // MARK: - Title Rect
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        switch iconAlignment {
        case .top:
            return topAlignedTitleRect(forContentRect: contentRect)
        case .bottom:
            return bottomAlignedTitleRect(forContentRect: contentRect)
        case .left:
            return leftAlignedTitleRect(forContentRect: contentRect)
        case .right:
            return rightAlignedTitleRect(forContentRect: contentRect)
        }
    }
    
    func topAlignedTitleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        let rect = super.titleRect(forContentRect: contentRect)
        
        let x = contentRect.minX
        let y = contentRect.height - rect.height + contentRect.minY
        let w = contentRect.width
        let h = rect.height
        
        return CGRect(
            x: x,
            y: y,
            width: w,
            height: h
        ).inset(by: titleEdgeInsets)
    }
    
    func bottomAlignedTitleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        let rect = super.titleRect(forContentRect: contentRect)
        
        let x = contentRect.minX
        let y = contentRect.minY
        let w = contentRect.width
        let h = rect.height
        
        return CGRect(
            x: x,
            y: y,
            width: w,
            height: h
        ).inset(by: titleEdgeInsets)
    }
    
    func leftAlignedTitleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        let titleRect = super.titleRect(forContentRect: contentRect)
        let imageRect = self.imageRect(forContentRect: contentRect)
        
        let x = imageRect.width + imageRect.minX
        let y = (contentRect.height - titleRect.height) / 2.0 + contentRect.minY
        let w = contentRect.width - imageRect.width * 2.0
        let h = titleRect.height
        
        return CGRect(
            x: x,
            y: y,
            width: w,
            height: h
        ).inset(by: titleEdgeInsets)
    }
    
    func rightAlignedTitleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        let titleRect = super.titleRect(forContentRect: contentRect)
        let imageRect = self.imageRect(forContentRect: contentRect)
        
        let x = contentRect.minX + imageRect.width
        let y = (contentRect.height - titleRect.height) / 2.0 + contentRect.minY
        let w = contentRect.width - imageRect.width * 2.0
        let h = titleRect.height
        
        return CGRect(
            x: x,
            y: y,
            width: w,
            height: h
        ).inset(by: titleEdgeInsets)
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel?.textAlignment = titleAlignment
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        titleLabel?.textAlignment = titleAlignment
    }
}
