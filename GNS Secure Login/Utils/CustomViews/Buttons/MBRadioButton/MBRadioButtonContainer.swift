//
//  MBRadioButtonContainer.swift
//  MandoBee
//
//  Created by Peter Bassem on 27/07/2021.
//

import UIKit
#if canImport(MBRadioCheckboxButton)
//import MBRadioCheckboxButton

protocol MBRadioButtonContainerDelegate: AnyObject {
    func mBRadioButtonContainerDidSelect(_ button: MBRadioButton, isSelected selected: Bool)
}

class MBRadioButtonContainer: RadioButtonContainer {
    
    // MARK: - Variables
    weak var rdbDelegate: MBRadioButtonContainerDelegate?
}
#endif
