//
//  KingfisherHelpers.swift
//  MandoBee
//
//  Created by Peter Bassem on 16/06/2021.
//

import Foundation
import UIKit
import Kingfisher

enum ImageType {
    case person
    case other
}

let placeholderUserImage = #imageLiteral(resourceName: "")
let placeholder = #imageLiteral(resourceName: "")

func downloadImage(_ imageView: UIImageView, withImageUrlString imageUrlString: String, imageType: ImageType) {
    let imageViewPlaceholder = imageType == .person ? placeholderUserImage : placeholder
    let imageUrl = imageUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    guard let imageURL = URL(string: imageUrl) else {
        imageView.image = imageViewPlaceholder
        return
    }
    imageView.kf.indicatorType = .activity
    imageView.kf.setImage(with: imageURL, placeholder: imageViewPlaceholder, options: [.transition(.fade(0.2))], completionHandler: { (result) in
        switch result {
        case .failure(_):
            imageView.image = imageViewPlaceholder
        default: return
        }
    })
}

func downloadImage(_ button: UIButton, withImageUrlString imageUrlString: String, imageType: ImageType) {
    let imageViewPlaceholder = imageType == .person ? placeholderUserImage : placeholder
    let imageUrl = imageUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    guard let imageURL = URL(string: imageUrl) else {
        button.setImage(imageViewPlaceholder, for: .normal)
        return
    }
    let modifier = AnyImageModifier { return $0.withRenderingMode(.alwaysOriginal) }
    button.kf.setImage(with: imageURL, for: .normal, placeholder: imageViewPlaceholder, options: [.imageModifier(modifier)], completionHandler: { (result) in
        switch result {
        case .failure(_):
            button.setImage(imageViewPlaceholder, for: .normal)
        default: return
        }
    })
}
