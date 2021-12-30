//
//  TitledLabelSwitch.swift
//  MandoBee
//
//  Created by Peter Bassem on 27/07/2021.
//

import UIKit
#if canImport(LabelSwitch)
//import LabelSwitch

protocol TitledLabelSwitchProtocol: AnyObject {
    func titledLabelSwitchDidSelectRightState(_ labelswitch: TitledLabelSwitch)
    func titledLabelSwitchDidSelectLeftState(_ labelswitch: TitledLabelSwitch)
}

@IBDesignable
class TitledLabelSwitch: LabelSwitch {
    
    // MARK: - IBInspectable
    @IBInspectable var leftText: String = ""
    @IBInspectable var leftTextColor: UIColor = DesignSystem.Colors.secondaryActionText.color
    @IBInspectable var leftBackgroundColor: UIColor = DesignSystem.Colors.primaryActionText.color
    
    @IBInspectable var rightText: String = ""
    @IBInspectable var rightTextColor: UIColor = DesignSystem.Colors.primaryActionText.color
    @IBInspectable var rightBackgroundColor: UIColor = DesignSystem.Colors.secondaryActionText.color
    
    weak var tlsDelegate: TitledLabelSwitchProtocol?
    
    // MARK: - Init
    override init(center: CGPoint, leftConfig: LabelSwitchConfig, rightConfig: LabelSwitchConfig, circlePadding: CGFloat = 1, minimumSize: CGSize = .zero, defaultState: LabelSwitchState = .L) {
        super.init(center: center, leftConfig: leftConfig, rightConfig: rightConfig, circlePadding: circlePadding, minimumSize: minimumSize, defaultState: defaultState)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Private Configurations
    private func configure() {
        fullSizeTapEnabled = true
        circleShadow = false
        circleColor = DesignSystem.Colors.primaryActionBackground.color
        switchConfigL = LabelSwitchConfig(text: leftText.localized(), textColor: leftTextColor, font: DesignSystem.Typography.action.font, backgroundColor: leftBackgroundColor)
        switchConfigR = LabelSwitchConfig(text: rightText.localized(), textColor: rightTextColor, font: DesignSystem.Typography.action.font, backgroundColor: rightBackgroundColor)
        delegate = self
    }
}

extension TitledLabelSwitch: LabelSwitchDelegate {
    
    func switchChangToState(sender: LabelSwitch) {
        print(sender.curState)
    }
}
#endif
