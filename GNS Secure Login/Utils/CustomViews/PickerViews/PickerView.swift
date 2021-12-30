//
//  PickerView.swift
//  Generic_PickerView
//
//  Created by Peter Bassem on 6/13/20.
//  Copyright © 2020 Peter Bassem. All rights reserved.
//

import UIKit

class PickerView: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    typealias ItemSelector = (_ row: Int) -> Void
    typealias RawConfigurator = (_ row: Int) -> String
    
    private var itemsCount: Int
    private var rawConfigurator:RawConfigurator
    private var itemSelection: ItemSelector
    
    init(itemsCount: Int, rawConfigurator:@escaping RawConfigurator, itemSelection: @escaping ItemSelector) {
        self.itemsCount = itemsCount
        self.rawConfigurator = rawConfigurator
        self.itemSelection = itemSelection
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemsCount
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rawConfigurator(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        itemSelection(row)
    }
}
