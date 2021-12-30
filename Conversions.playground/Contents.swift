import UIKit
import Foundation

extension StringProtocol {
    func dropping<S: StringProtocol>(prefix: S) -> SubSequence { hasPrefix(prefix) ? dropFirst(prefix.count) : self[...] }
    var hexaToDecimal: Int { Int(dropping(prefix: "0x"), radix: 16) ?? 0 }
    var hexaToBinary: String { .init(hexaToDecimal, radix: 2) }
    var decimalToHexa: String { .init(Int(self) ?? 0, radix: 16) }
    var decimalToBinary: String { .init(Int(self) ?? 0, radix: 2) }
    var binaryToDecimal: Int { Int(dropping(prefix: "0b"), radix: 2) ?? 0 }
    var binaryToHexa: String { .init(binaryToDecimal, radix: 16) }
}

extension BinaryInteger {
    var binary: String { .init(self, radix: 2) }
    var hexa: String { .init(self, radix: 16) }
}

//print("D".hexaToDecimal)

//============================================================================================================//

let nFCSitesDictionary = ["20E": 1, "093": 3, "12E": 0, "098": 4, "11E": 2]
let fileIndex = nFCSitesDictionary["098"]
//print(fileIndex)

//============================================================================================================//

let responseData: [UInt8] = [116, 101, 115, 116, 85, 115, 101, 114, 110, 97, 109, 101, 10, 116, 101, 115, 116, 80, 97, 115, 115, 119, 111, 114, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].filter { $0 != 0 }
let datastring = String(bytes: responseData, encoding: .utf8)
print(datastring)
