//
//  BasePresenter.swift
//  Aman Elshark
//
//  Created by Peter Bassem on 1/12/20.
//  Copyright © 2020 Peter Bassem. All rights reserved.
//

import Foundation
import UIKit

class BasePresenter {
    
    func showErrorAlert(error: String) {
        AlertView.AlertViewBuilder().setTitle(with: LocalizationSystem.sharedInstance.localizedStringForKey(key: "error", comment: ""))
            .setMessage(with: error)
            .setAlertType(with: .failure)
            .setButtonTitle(with: LocalizationSystem.sharedInstance.localizedStringForKey(key: "done", comment: ""))
            .build()
    }

    func secondsToHoursMinutesSeconds (seconds: Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func setFont(size fontSize: CGFloat, isBold bold: Bool) -> UIFont {
        if LocalizationSystem.sharedInstance.getLanguage() == "en" {
            return UIFont(name: bold ? "Bariol-Bold" : "Bariol-Regular", size: fontSize)!
        } else {
            return UIFont(name: bold ? "NotoKufiArabic-Bold" : "NotoKufiArabic", size: (fontSize - 2.0))!
        }
    }
    
    func downloadImage(withImageUrlString imageUrlString: String, completion: @escaping (UIImage?) -> Void) {
        let imageUrl = imageUrlString.removeWhitespace().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let imageURL = URL(string: imageUrl) else { return }
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async() {
                completion(image)
            }
        }.resume()
    }
}
