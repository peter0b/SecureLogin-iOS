//
//  MultiLineTitleButton.swift
//  MandoBee
//
//  Created by Peter Bassem on 08/07/2021.
//

import UIKit

class MultiLineTitleButton: UIButton {

    // MARK: - IBInspectable
    @IBInspectable
    var lineNumbers: Int = 2 { didSet { configure() } }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    // MARK: - Private Configuration
    private func configure() {
        titleLabel?.numberOfLines = lineNumbers
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.textAlignment = .center
        contentEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
        titleLabel?.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .horizontal)
        
        imageView?.contentMode = .scaleAspectFill
        imageView?.cornerRadius = 15
        imageView?.shadowOpacity = 1
        imageView?.shadowOffsetX = 1
        imageView?.shadowOffsetY = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = bounds
    }
}
