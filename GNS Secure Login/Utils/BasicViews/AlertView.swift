//
//  AlertView.swift
//  CustomAlert
//
//  Created by SHUBHAM AGARWAL on 31/12/18.
//  Copyright © 2018 SHUBHAM AGARWAL. All rights reserved.
//

//NOTE:
//Don't Forget to add images from resources to Assets.xcassets

import Foundation
import UIKit

class AlertView: UIView {
    
    var onDoneClicked: (()->Void)?
    
    static let instance = AlertView()
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        commonInit()
    }
    
    func setAttributes(title: String?, message: String?, buttonTitle: String? = LocalizationSystem.sharedInstance.localizedStringForKey(key: "done", comment: ""), alertType: AlertType? = .success, onCompletion completion: (() -> Void)?) {
        titleLabel.text = title
        messageLabel.text = message
        doneButton.setTitle(buttonTitle, for: UIControl.State.normal)
        switch alertType! {
        case .success:
            imageView.image = UIImage(named: "success") //!.imageWithColor(color: COLORS.mainColor)
            doneButton.backgroundColor = UIColor(hexString: "#54A2BF") //COLORS.mainColor
            doneButton.tag = 0
        case .failure:
            imageView.image = UIImage(named: "Failure") //!.imageWithColor(color: COLORS.mainColor)
            doneButton.backgroundColor = .red
            doneButton.tag = 1
        }
        onDoneClicked = completion
        keyWindow?.addSubview(parentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        parentView.backgroundColor = UIColor(rgbValue: 0xffffff, alpha: 0.3)
        
        imageView.layer.cornerRadius = 30
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        
        alertView.layer.cornerRadius = 10
//
//        titleLabel.font = setFont(size: 22.0, isBold: true, englishFont: .Roboto)
        
//        messageLabel.font = setFont(size: 19.0, isBold: false, englishFont: .Roboto)
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
//        doneButton.titleLabel?.font = setFont(size: 17.0, isBold: false, englishFont: .Roboto)
        doneButton.layer.cornerRadius = 10
        
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    enum AlertType {
        case success
        case failure
    }
    
    class AlertViewBuilder {
        private var title: String?
        private var message: String?
        private var buttonTitle: String?
        private var alertType: AlertType = .success
        private var buttonClick: (() -> Void)?
        
        func setTitle(with title: String) -> AlertViewBuilder { self.title = title; return self }
        
        func setMessage(with message: String) -> AlertViewBuilder { self.message = message; return self }
        
        func setButtonTitle(with buttonTitle: String) -> AlertViewBuilder { self.buttonTitle = buttonTitle; return self }
        
        func setAlertType(with alertType: AlertType) -> AlertViewBuilder { self.alertType = alertType; return self }
        
        func onButtonClick(with completion: @escaping (() -> Void)) -> AlertViewBuilder { self.buttonClick = completion; return self }
        
        func build() {
            AlertView.instance.setAttributes(title: title, message: message, buttonTitle: buttonTitle, alertType: alertType, onCompletion: buttonClick)
        }
    }
    
    @IBAction func onClickDone(_ sender: UIButton) {
        onDoneClicked?()
        parentView.removeFromSuperview()
    }
}
