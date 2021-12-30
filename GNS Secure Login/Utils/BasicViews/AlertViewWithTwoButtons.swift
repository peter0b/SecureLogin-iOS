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

class AlertViewWithTwoButtons: UIView {
    
    static let instance = AlertViewWithTwoButtons()
    
    var onCancelClicked: (()->Void)?
    var onDoneClicked: (()->Void)?
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertViewWithTwoButtons", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttributes(title: String?, message: String?, leftButtonTitle: String? = LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancel", comment: ""), rightButtonTitle: String? = LocalizationSystem.sharedInstance.localizedStringForKey(key: "done", comment: ""), alertType: AlertViewWithTwoButtonsType? = .success, onLeftButtonCompletion leftCompletion: (() -> Void)?, onRightButtonCompletion rightCompletion: (()->Void)?) {
        titleLabel.text = title
        messageLabel.text = message
        cancelButton.setTitle(leftButtonTitle, for: .normal)
        doneButton.setTitle(rightButtonTitle, for: UIControl.State.normal)
        switch alertType! {
        case .success:
            imageView.image = UIImage(named: "success") //!.imageWithColor(color: COLORS.mainColor)
            doneButton.backgroundColor = .black //COLORS.mainColor
            doneButton.tag = 0
        case .failure:
            imageView.image = UIImage(named: "Failure")  //!.imageWithColor(color: COLORS.mainColor)
            doneButton.backgroundColor = .green
            doneButton.tag = 1
        }
        onCancelClicked = leftCompletion
        onDoneClicked = rightCompletion
        keyWindow?.addSubview(parentView)
    }
    
    private func commonInit() {
        parentView.backgroundColor = UIColor(rgbValue: 0xffffff, alpha: 0.3)
        
        imageView.layer.cornerRadius = 30
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        
        alertView.layer.cornerRadius = 10
        
//        titleLabel.font = setFont(size: 22.0, isBold: true)
        
//        messageLabel.font = setFont(size: 19.0, isBold: false)
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
//        cancelButton.titleLabel?.font = setFont(size: 17.0, isBold: false)
        cancelButton.layer.cornerRadius = 10
        cancelButton.backgroundColor = .lightGray
        cancelButton.setTitleColor(.white, for: UIControl.State.normal)
        
//        doneButton.titleLabel?.font = setFont(size: 17.0, isBold: false)
        doneButton.layer.cornerRadius = 10
        doneButton.backgroundColor = .black //COLORS.mainColor
        doneButton.setTitleColor(.white, for: UIControl.State.normal)
        
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    enum AlertViewWithTwoButtonsType {
        case success
        case failure
    }
    
    class AlertViewWithTwoButtonsBuilder {
        private var title: String?
        private var message: String?
        private var leftButtonTitle: String?
        private var rightButtonTitle: String?
        private var alertType: AlertViewWithTwoButtonsType = .success
        private var leftButtonClick: (()->Void)?
        private var rightButtonClick: (()->Void)?
        
        func setTitle(with title: String) -> AlertViewWithTwoButtonsBuilder { self.title = title; return self }
        
        func setMessage(with message: String) -> AlertViewWithTwoButtonsBuilder { self.message = message; return self }
        
        func setLeftButtonTitle(with buttonTitle: String) -> AlertViewWithTwoButtonsBuilder { self.leftButtonTitle = buttonTitle; return self }
        
        func setRighteftButtonTitle(with buttonTitle: String) -> AlertViewWithTwoButtonsBuilder { self.rightButtonTitle = buttonTitle; return self }
        
        func setAlertType(with alertType: AlertViewWithTwoButtonsType) -> AlertViewWithTwoButtonsBuilder { self.alertType = alertType; return self }
        
        func onLeftButtonClick(with completion: @escaping (() -> Void)) -> AlertViewWithTwoButtonsBuilder { self.leftButtonClick = completion; return self }
        
        func onRightButtonClick(with completion:@escaping(()->Void)) -> AlertViewWithTwoButtonsBuilder { self.rightButtonClick = completion; return self }
        
        func build() {
            AlertViewWithTwoButtons.instance.setAttributes(title: title, message: message, leftButtonTitle: leftButtonTitle, rightButtonTitle: rightButtonTitle, alertType: alertType, onLeftButtonCompletion: leftButtonClick, onRightButtonCompletion: rightButtonClick)
        }
        
    }
    
//    func showAlert(title: String, message: String, leftButtonTitle: String?, rightButtonTitle: String?, alertType: AlertViewWithTwoButtonsType, onCancelCompletion leftButtonCompletion: (() -> Void)?, onDoneCompletion rightButtonCompletion: (() -> Void)?) {
//        self.titleLabel.text = title
//        self.messageLabel.text = message
//        self.cancelButton.setTitle(leftButtonTitle ?? LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancelButton", comment: ""), for: UIControl.State.normal)
//        self.doneButton.setTitle(rightButtonTitle ?? LocalizationSystem.sharedInstance.localizedStringForKey(key: "doneButton", comment: ""), for: UIControl.State.normal)
//
//        switch alertType {
//        case .success:
//            imageView.image = UIImage(named: "success")
//            doneButton.backgroundColor = COLORS.mainColor
//            doneButton.tag = 0
//        case .failure:
//            imageView.image = UIImage(named: "Failure")
//            doneButton.backgroundColor = COLORS.alertViewErrorColor
//            doneButton.tag = 1
//        }
//        self.onCancelClicked = leftButtonCompletion
//        self.onDoneClicked = rightButtonCompletion
//        UIApplication.shared.keyWindow?.addSubview(parentView)
//    }
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        onCancelClicked?()
        parentView.removeFromSuperview()
    }
    
    @IBAction func onClickDone(_ sender: UIButton) {
        onDoneClicked?()
        parentView.removeFromSuperview()
    }
    
//    @IBAction func onClickDone(_ sender: UIButton) {
//         onDoneClicked?()
//        parentView.removeFromSuperview()
//    }
}
