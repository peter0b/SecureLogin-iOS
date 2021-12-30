//
//  NoDataViewController.swift
//  CorpyEcommerce
//
//  Created by Peter Bassem on 11/25/18.
//  Copyright © 2018 corpy. All rights reserved.
//

import UIKit

class NoDataViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var noDataImageView: UIImageView!
    @IBOutlet weak var noDataAvailableLabel: UILabel!
    
    //MAR:- Properties

    //MARK:- Main Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        noDataImageView.image = UIImage(named: "no-data")
        noDataImageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        noDataAvailableLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "noData", comment: "")
        noDataAvailableLabel.font = DesignSystem.Typography.display2.font
    }
}
