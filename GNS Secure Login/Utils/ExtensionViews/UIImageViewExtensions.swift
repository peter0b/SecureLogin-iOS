//
//  UIImageViewExtensions.swift
//  Driver
//
//  Created by Peter Bassem on 27/12/2020.
//  Copyright © 2020 Eslam Maged. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    @IBInspectable var flipRightToLeft: Bool {
        set {
            if LocalizationHelper.isArabic() == true && newValue == true {
                let rotatedImage = image?.flippedImageToRight()
                image = rotatedImage
            }
        }
        get {
            return self.flipRightToLeft
        }
    }

    func setImageWith(urlString: String, placeholder: UIImage? = nil, indicator: IndicatorType = .activity, completion: ((_: UIImage?) -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            if let url = URL(string: urlString) {
                self?.kf.indicatorType = indicator
                self?.kf.setImage(with: url, placeholder: placeholder, options: [], completionHandler: { result in
                    switch result {
                    case .success(_):
                        completion?(self?.image)
                    case .failure(_):
                        if placeholder == nil {
                            self?.setDefaultImage()
                        } else {
                            self?.image = placeholder
                        }
                    }
                })
            } else {
                if placeholder == nil {
                    self?.setDefaultImage()
                } else {
                    self?.image = placeholder
                }
            }
        }
    }

    private func setDefaultImage() {
        image = UIImage(color: #colorLiteral(red: 0.9499999881, green: 0.9499999881, blue: 0.9499999881, alpha: 1), size: bounds.size)
    }
    
    
    func setImageColor(color: UIColor) {
      let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
      self.image = templateImage
      self.tintColor = color
    }
    
    func flipImage() {
        if !LocalizationHelper.isArabic() {
            transform = CGAffineTransform(scaleX: -1, y: 1)
        } else { return }
    }
}

// MARK: - Get Image From URL
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
