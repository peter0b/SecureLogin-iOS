//
//  ArrayExtensions.swift
//  Driver
//
//  Created by Peter Bassem on 27/12/2020.
//  Copyright © 2020 Eslam Maged. All rights reserved.
//

import Foundation

extension Array {

    var middle: Element? {
        guard count != 0 else { return nil }

        let middleIndex = (count > 1 ? count - 1 : count) / 2
        return self[middleIndex]
    }
}

extension Array where Element: Encodable {

    func asDictionaryFromArray() -> [[String: Any]] {
        var dict = [[String: Any]]()

        _ = self.map {
            if let objectDict = $0.dictionary {
                dict.append(objectDict)
            }
        }
        return dict
    }
}

extension Array where Element: Equatable {
    
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}

extension Array where Element: Equatable {

    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }

}

extension BinaryInteger where Self: FixedWidthInteger {

    /// Safely converts Float to BinaryInteger (Uint8, Uint16, Int8, and so on), truncate remains that do not fit in the instance of BinaryInteger range value.
    /// For instance, if Float value is 300.934, and self is UInt8, it will be 255, or if Float value is -100.2342, self value will be 0
    init(truncateToFit float: Float) {
        switch float {
        case _ where float < Float(Self.min): self.init(Self.min)
        case _ where float > Float(Self.max): self.init(Self.max)
        default: self.init(float)
        }
    }

    /// Safely converts Double to BinaryInteger (Uint8, Uint16, Int8, and so on), truncate remains that do not fit in the instance of BinaryInteger range value.
    /// For instance, if Double value is 300.934, and self is UInt8, it will be 255, or if Float value is -100.2342, self value will be 0
    init(truncateToFit double: Double) {
        switch double {
        case _ where double < Double(Self.min): self.init(Self.min)
        case _ where double > Double(Self.max): self.init(Self.max)
        default: self.init(double)
        }
    }
}
