//
//  NoInternetConnectionViewController.swift
//  CorpyEcommerce
//
//  Created by Peter Bassem on 11/12/18.
//  Copyright © 2018 corpy. All rights reserved.
//

//NOTE:
//Add the images from assets folder in Utils to Assets.xcassets

import UIKit

class NoInternetConnectionViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var noInternetImageView: UIImageView!
    @IBOutlet weak var noInternetConnectionLabel: UILabel!
    @IBOutlet weak var noInternetRefreshArrowImageView: UIImageView!
    @IBOutlet weak var pressAgainLabel: UILabel!
    
    //MARK:- Main Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        noInternetImageView.image = UIImage(named: "no-internet")?.imageWithColor(color: .red)
        noInternetImageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        noInternetConnectionLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "noInternetConnectionLabel", comment: "")
        noInternetConnectionLabel.font = DesignSystem.Typography.display2.font //setFont(size: 19.0, isBold: true)
        
        noInternetRefreshArrowImageView.image = UIImage(named: "no-internet-refresh-arrow")
        noInternetRefreshArrowImageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        pressAgainLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "pressAgainLabel", comment: "")
        pressAgainLabel.font = DesignSystem.Typography.paragraphSmall.font //setFont(size: 17.0, isBold: false)
    }
}
