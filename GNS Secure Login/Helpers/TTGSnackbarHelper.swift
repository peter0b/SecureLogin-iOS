//
//  TTGSnackbarHelper.swift
//  Dars
//
//  Created by Peter Bassem on 11/12/20.
//  Copyright © 2020 Peter Bassem. All rights reserved.
//

import Foundation
import TTGSnackbar

class TTGSnackbarHelper {
    
    enum SnackbarLocation {
        case top, bottom, any
    }
    
    private static var snackbar: TTGSnackbar?
    
    class func showSnackBar(withBackgroundColor backgroundColor: UIColor = DesignSystem.Colors.background5.color,
                            inView view: UIView? = nil,
                            withAnimationDuration animationDuration: TimeInterval = 0.5,
                            wihthLocationInView location: SnackbarLocation = .bottom,
                            withMessage message: String,
                            withMessageFont messageFont: UIFont = DesignSystem.Typography.paragraphSmall.font,
                            withMessageTextColor messageTextColor: UIColor = .white,
                            withDuration duration: TTGSnackbarDuration = .middle,
                            withActionText actionText: String = "",
                            withActionTextFont actionTextFont: UIFont = DesignSystem.Typography.paragraphSmall.font,
                            withActionTextColor actionTextColor: UIColor = .white,
                            withActionBlock actionBlock: @escaping TTGSnackbar.TTGActionBlock) {
        if snackbar == nil {
            snackbar = TTGSnackbar.init(message: message, duration: duration, actionText: actionText, messageFont: messageFont, actionTextFont: actionTextFont, actionBlock: actionBlock)
            snackbar?.messageTextColor = messageTextColor
            snackbar?.actionTextColor = actionTextColor
            snackbar?.contentInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
            snackbar?.topMargin = 0
            snackbar?.leftMargin = 0
            snackbar?.bottomMargin = 0
            snackbar?.rightMargin = 0
            snackbar?.containerView = view
//            snackbar?.heightAnchor.constraint(equalToConstant: 100).isActive = true //working
            snackbar?.layer.cornerRadius = 0
            snackbar?.layer.masksToBounds = true
            snackbar?.backgroundColor = backgroundColor
            snackbar?.animationDuration = animationDuration
            switch location {
            case .top: snackbar?.animationType = .slideFromTopBackToTop
            case .bottom: snackbar?.animationType = .slideFromBottomBackToBottom
            case .any: snackbar?.animationType = .fadeInFadeOut
            }
            snackbar?.shouldDismissOnSwipe = true
            snackbar?.onTapBlock = { _ in self.snackbar?.dismiss() }
            snackbar?.messageTextAlign = LocalizationHelper.isArabic() ? .right : .left
            snackbar?.show()
            snackbar?.dismissBlock = { _ in self.snackbar = nil }
        }
    }
}
