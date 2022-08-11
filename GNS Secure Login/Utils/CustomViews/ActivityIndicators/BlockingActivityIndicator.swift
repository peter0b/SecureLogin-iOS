//
//  BlockingActivityIndicator.swift
//  TeacherOnDemand
//
//  Created by Peter Bassem on 03/05/2022.
//  Copyright © 2022 LighthouseHF. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

final class BlockingActivityIndicator: UIView {
  private let activityIndicator: NVActivityIndicatorView

  override init(frame: CGRect) {
    self.activityIndicator = NVActivityIndicatorView(
      frame: CGRect(
        origin: .zero,
        size: NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE
      )
    )
      activityIndicator.color = DesignSystem.Colors.primary.color
      activityIndicator.type = .ballSpinFadeLoader
    activityIndicator.startAnimating()
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    super.init(frame: frame)
    backgroundColor = DesignSystem.Colors.backgroundTransparentColor.color
    addSubview(activityIndicator)
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension UIWindow {
  func startBlockingActivityIndicator() {
    guard !subviews.contains(where: { $0 is BlockingActivityIndicator }) else {
      return
    }

    let activityIndicator = BlockingActivityIndicator()
    activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    activityIndicator.frame = bounds

    UIView.transition(
      with: self,
      duration: 0.3,
      options: .transitionCrossDissolve,
      animations: {
        self.addSubview(activityIndicator)
      }
    )
  }
    
    func stopBlockingActivityIndicator() {
        guard subviews.contains(where: { $0 is BlockingActivityIndicator }) else {
          return
        }
        
        subviews.forEach {
            if let activityIndicator = $0 as? BlockingActivityIndicator {
                UIView.transition(
                  with: self,
                  duration: 0.3,
                  options: .transitionCrossDissolve,
                  animations: {
                      activityIndicator.removeFromSuperview()
                  }
                )
            }
        }
    }
}
