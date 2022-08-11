//
//  NotificationBannerManager.swift
//  Awlem
//
//  Created by Kerolles Roshdi on 12/30/20.
//

import Foundation
import NotificationBannerSwift

class NotificationBannerManager {
    
    static func show(title: String, style: BannerStyle) {
        NotificationBannerQueue.default.dismissAllForced()
        let font = DesignSystem.Typography.buttonSmall.font
        let rightView = UIImageView(image: DesignSystem.Icon.iconError.image)
        let banner = FloatingNotificationBanner(
            title: title,
            titleFont: font,
            titleColor: .white,
            titleTextAlign: .center,
            rightView: rightView,
            style: style,
            iconPosition: .center
        )
        banner.show()
    }
    
}
