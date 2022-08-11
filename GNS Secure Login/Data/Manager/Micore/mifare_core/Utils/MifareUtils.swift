//
//  MifareUtils.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 29/07/2021.
//

import Foundation
import IDZSwiftCommonCrypto

class MifareUtils {
    
    /// Converts the byte array to HEX string.
    ///
    /// - Parameter buffer: the buffer
    /// - Returns: the HEX string
    static func toHexString(buffer: [UInt8]) -> String {
        var bufferString = ""
        for i in 0..<buffer.count {
            if i == 0 {
                bufferString += String(format: "%02X", buffer[i])
            } else {
                bufferString += String(format: " %02X", buffer[i])
            }
        }
        return bufferString
    }
    
    /// Converts the byte array to HEX string.
    ///
    /// - Parameter buffer: the buffer
    /// - Returns: the HEX string
    static func toHexString(buffer: UInt8) -> String {
        var bufferString = ""
        bufferString += String(format: "%02X", buffer)
        return bufferString
    }
    
    static func toHexString(string: String) -> String {
        let data = Data(string.utf8)
        return data.map{ String(format:"%02x", $0) }.joined()
    }
    
    static func toHexString(buffer: Int) -> String {
        var bufferString = ""
        bufferString += String(format: "%02X", buffer)
        return bufferString
    }
    
    /// Converts the byte array to HEX string.
    ///
    /// - Parameter data: the data
    /// - Returns: the HEX string
    static func toHexString(data: Data) -> String {
        return String(decoding: data, as: UTF8.self)
    }
    
    static func toString(hexString: String) -> String {
        let data = Data(fromHexEncodedString: hexString)!
        return String(data: data, encoding: .isoLatin1)!
    }
    
    /***
     * Given a byte array, convert it to a hexadecimal representation.
     *
     * @param data: Byte Array
     * @return String containing the hexadecimal representation
     */
    static func toHexString(data: [UInt8]) -> String {
        var hexString: String = ""
        for item in data {
            let hex = String(format: "%02x", item)
            hexString.append(hex)
        }
        return hexString
    }
    
    static func decrypte(data: [UInt8], key: [UInt8], IV: [UInt8]) throws -> [UInt8]? {
        let cipher = MifareUtils.getCipher(mode: .decrypt, key: key, IV: IV)
        return cipher.update(byteArray: data)?.final()
    }
    
    static func encrypt(data: [UInt8], key: [UInt8], IV: [UInt8]) throws -> [UInt8]? {
        let cipher = MifareUtils.getCipher(mode: .encrypt, key: key, IV: IV)
        return cipher.update(byteArray: data)?.final()
    }
    
    private static func getCipher(mode: StreamCryptor.Operation, key: [UInt8], IV: [UInt8]) -> Cryptor {
        let cryptor = Cryptor(operation: mode, algorithm: .des, mode: .CBC, padding: .NoPadding, key: key, iv: IV)
        return cryptor
    }
    
    static func rotateLeft(data: [UInt8]) -> [UInt8] {
        var rotated = [UInt8](repeating: 0x00, count: data.count)
        rotated[data.count - 1] = data[0]
        for i in 0..<(data.count - 1) {
            rotated[i] = data[i + 1]
        }
        return rotated
    }
    
    static func rotateRight(data: [UInt8]) -> [UInt8] {
        var unrotated = [UInt8](repeating: 0x00, count: data.count)
        for i in 1..<data.count {
            unrotated[i] = data[i - 1]
        }
        unrotated[0] = data[data.count - 1]
        return unrotated
    }
    
    static func concatentate(dataA: [UInt8], dataB: [UInt8]) -> [UInt8] {
        var concatenated = [UInt8](repeating: 0x00, count: dataA.count + dataB.count)
        for i in 0..<dataA.count {
            concatenated[i] = dataA[i]
        }
        for i in 0..<dataB.count {
            concatenated[dataA.count + i] = dataB[i]
        }
        return concatenated
    }
    
    static func copyOfRange<T>(arr: [T], from: Int, to: Int) -> [T]? where T: ExpressibleByIntegerLiteral {
        guard from >= 0 && from <= arr.count && from <= to else { return nil }

        var to = to
        var padding = 0

        if to > arr.count {
            padding = to - arr.count
            to = arr.count
        }

        return Array(arr[from..<to]) + [T](repeating: 0, count: padding)
    }
    
    static func byteArrayToHex(bytes: [UInt8]) -> String {
        var bufferString = ""
        for byte in bytes {
            bufferString += String(format: "%02X", byte)
        }
        return bufferString
    }
    
    static func hexToByteArray(hexString: String) -> [UInt8] {
        return [UInt8](hexString.utf8)
    }
    
    static func hextToByte(hexString: String) -> UInt8 {
        return [UInt8](hexString.utf8).first!
    }
    
    static func getBytes<T>(_ value: T) -> [UInt8] {
        var value = value
        return withUnsafePointer(to: &value) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<T>.size) {
                Array(UnsafeBufferPointer(start: $0, count: MemoryLayout<T>.size))
            }
        }
    }
    
    static func toByteArray<T>(_ value: T) -> [UInt8] {
        var value = value
        return withUnsafePointer(to: &value) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<T>.size) {
                Array(UnsafeBufferPointer(start: $0, count: MemoryLayout<T>.size))
            }
        }
    }
    
    static func removeRange( list: inout [UInt8], index: Int, count: Int) {
        var count = count
        let size = list.count
        if index < 0 { return }
        if count < 0 { return }
        if (size - index) < count { return }
        let tempList = list
        if count > 0 {
            if size >= (index + count) {
                for i in index...tempList.count {
                    if count > 0 {
                        list.remove(object: tempList[i])
                        count -= 1
                    }
                }
            }
        }
    }
    
    static func getDataFrame(cla: ApduEnums.Cla, ins: ApduEnums.Ins, p1: UInt8, p2: UInt8, le: UInt8, data: inout [UInt8]) -> [UInt8] {
        let frameLen = 54
        var frameBytes: [UInt8]? = nil
        if data.count > frameLen {
            frameBytes = getBytes(frameLen)
            removeRange(list: &data, index: 0, count: frameLen)
        } else {
            frameBytes = data
        }
        var apduBytes: [UInt8] = []
        apduBytes.append(cla.rawValue)
        apduBytes.append(ins.rawValue)
        apduBytes.append(p1)
        apduBytes.append(p2)
        if frameBytes?.isEmpty == false {
            apduBytes.append(contentsOf: getBytes(frameBytes?.count ?? 0))
            apduBytes.append(contentsOf: frameBytes ?? [])
        }
        apduBytes.append(le)
        return apduBytes
    }
    
    static func getData(cla: ApduEnums.Cla, ins: ApduEnums.Ins, p1: UInt8, p2: UInt8, le: UInt8, data: [UInt8]) -> [UInt8] {
        var apduBytes: [UInt8] = []
        apduBytes.append(cla.rawValue)
        apduBytes.append(ins.rawValue)
        apduBytes.append(p1)
        apduBytes.append(p2)
        if !data.isEmpty {
            if data.count < 256 {
                apduBytes.append(contentsOf: getBytes(data.count))
            }
            apduBytes.append(contentsOf: data)
        }
        apduBytes.append(le)
        return apduBytes
    }
    
    public static func toInt32( bytes: [UInt8], index: Int) throws -> Int {
        if (bytes.count != 4) {
            throw fatalError("The length of the byte array must be at least 4 bytes long.")
        }
        
//        return (Int) ((Int) (0xff & bytes[index]) << 56
//                        | (Int) (0xff & bytes[index + 1]) << 48
//                        | (Int) (0xff & bytes[index + 2]) << 40 | (Int) (0xff & bytes[index + 3]) << 32);
        
        let i1 = Int((0xff & bytes[index]) << 56)
        let i2 = Int((0xff & bytes[index + 1]) << 48)
        let i3 = Int((0xff & bytes[index + 2]) << 40)
        let i4 = Int((0xff & bytes[index + 3]) << 32)
        return Int ( i1 | i2 | i3 | i4)
    }
    
    static func toString(bytes: [UInt8]) -> String {
        return String(decoding: bytes, as: UTF8.self)
    }
    
    static func bytes<U: FixedWidthInteger,V: FixedWidthInteger>(
        of value    : U,
        to type     : V.Type,
        droppingZeros: Bool
        ) -> [V]{

        let sizeInput = MemoryLayout<U>.size
        let sizeOutput = MemoryLayout<V>.size

        precondition(sizeInput >= sizeOutput, "The input memory size should be greater than the output memory size")

        var value = value
        let a =  withUnsafePointer(to: &value, {
            $0.withMemoryRebound(
                to: V.self,
                capacity: sizeInput,
                {
                    Array(UnsafeBufferPointer(start: $0, count: sizeInput/sizeOutput))
            })
        })

        let lastNonZeroIndex =
            (droppingZeros ? a.lastIndex { $0 != 0 } : a.indices.last) ?? a.startIndex

        return Array(a[...lastNonZeroIndex].reversed())
    }
}
