//
//  BundleExtensions.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 25/08/2021.
//

import Foundation

extension Bundle {
    
    static func loadView<T>(withType type: T.Type) -> T {
        let nibName = String(describing: T.self)
        if let view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? T {
            return view
        }
        
        fatalError("Could not load view with type " + String(describing: type))
    }

}
