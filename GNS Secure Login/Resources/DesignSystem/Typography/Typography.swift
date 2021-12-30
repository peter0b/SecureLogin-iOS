//
//  Typography.swift
//  MandoBee
//
//  Created by Peter Bassem on 17/06/2021.
//

import Foundation
import UIKit

extension DesignSystem {

    enum Typography {
        case imageSize
        case display1
        case display2
        case paragraphSmall
        case buttonSmall
        case action
        case actionLarge
        case description
        
        private var fontDescriptor: CustomFontDescriptor {
            switch self {
            case .imageSize:
                return CustomFontDescriptor(font: .regular, size: 40, style: .largeTitle)
            case .display1:
                return CustomFontDescriptor(font: .bold, size: 32, style: .title1)
            case .display2:
                return CustomFontDescriptor(font: .bold, size: 20, style: .title1)
            case .paragraphSmall:
                return CustomFontDescriptor(font: .regular, size: 16, style: .subheadline)
            case .buttonSmall:
                return CustomFontDescriptor(font: .bold, size: 16, style: .callout)
            case .action:
                return CustomFontDescriptor(font: .bold, size: 18, style: .callout)
            case .actionLarge:
                return CustomFontDescriptor(font: .bold, size: 20, style: .callout)
            case .description:
                return CustomFontDescriptor(font: .boldItalic, size: 14, style: .caption1)
            }
        }
        
        var font: UIFont {
            guard let font = UIFont(name: fontDescriptor.font.name, size: fontDescriptor.size) else {
                return UIFont.preferredFont(forTextStyle: fontDescriptor.style)
            }
            let fontMerics = UIFontMetrics(forTextStyle: fontDescriptor.style)
            return fontMerics.scaledFont(for: font)
        }
    }
}
