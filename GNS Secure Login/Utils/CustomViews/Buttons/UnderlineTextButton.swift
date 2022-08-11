//
//  UnderlineTextButton.swift
//  MandoBee
//
//  Created by Peter Bassem on 06/07/2021.
//

import UIKit

class UnderlineTextButton: UIButton {

    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: .normal)
        self.setAttributedTitle(self.attributedString(), for: .normal)
    }

    private func attributedString() -> NSAttributedString? {
        let attributedTitle: [NSAttributedString.Key : Any] = [
            .font: DesignSystem.Typography.buttonSmall.font,
            .foregroundColor: DesignSystem.Colors.textPrimary.color,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(string: self.currentTitle!, attributes: attributedTitle)
        return attributedString
      }
}
