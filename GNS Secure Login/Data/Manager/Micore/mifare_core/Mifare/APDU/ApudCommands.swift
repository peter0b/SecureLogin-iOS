//
//  ApduCommand.swift
//  GNS.SecureLogin
//
//  Created by Paula Mansour on 5/2/19.
//  Copyright © 2019 Paula Mansour. All rights reserved.
//

import Foundation
import CryptoSwift

class ApduCommand {
    var cla: UInt8 = 0x00;
    var ins: UInt8 = 0x00;
    var p1: UInt8? = 0x00;
    var p2: UInt8? = nil;
    var le: UInt8? = nil;
    var data: [UInt8] = [];
    var useFrames: Bool = false;
    //var commandData: Data? = nil;
    var commandName: String = "";
    
    init(commandName: String, cla: ApduEnums.Cla, ins: ApduEnums.Ins, p1: UInt8, p2: UInt8?, le: UInt8?, data: [UInt8]) {
        self.cla = cla.rawValue;
        self.ins = ins.rawValue;
        self.p1 = p1;
        self.p2 = p2;
        self.le = le;
        self.data = data;
        self.commandName = commandName;
    }
    
    convenience init(commandName: String, cla: ApduEnums.Cla, ins: ApduEnums.Ins, p1: UInt8, p2: UInt8?, data: [UInt8]) {
        self.init(commandName: commandName, cla: cla, ins: ins, p1: p1, p2: p2, le: nil, data: data);
    }
    
    convenience init(commandName: String, cla: ApduEnums.Cla, ins: ApduEnums.Ins, data: [UInt8]) {
        self.init(commandName: commandName, cla: cla, ins: ins, p1: 0x00, p2: nil, data: data);
    }
    
    func getDataFrame() -> Data {
        let farmeLen: Int = 54;
        var frameBytes: [UInt8] = [];
        
        if data.count > farmeLen {
            frameBytes =  Array(data[0...farmeLen-1]);
            data.removeFirst(farmeLen);
        } else {
            frameBytes = data;
            data.removeFirst(frameBytes.count);
        }
        
        var apduBytes = [cla, ins, p1] as! [UInt8];
        if self.p2 != nil {
            apduBytes += [self.p2!];
        }
        if frameBytes.count > 0 {
            apduBytes += [UInt8(frameBytes.count)];
            apduBytes += frameBytes;
        }
        if self.le != nil {
            apduBytes += [self.le!];
        }
        return Data.init(bytes: apduBytes, count: apduBytes.count);
    }
    
    func getData() -> Data {
        return composeData(bytes: data);
    }
    
    private func composeData(bytes:  [UInt8]) -> Data {
        var apduBytes = [cla, ins, p1] as! [UInt8];
        if self.p2 != nil {
            apduBytes += [self.p2!];
        }
        if bytes.count > 0 {
            if bytes.count < 256 {
                apduBytes += [UInt8(bytes.count)];
            }
            apduBytes += bytes;
        }
        if self.le != nil {
            apduBytes += [self.le!];
        }
        return Data.init(bytes: apduBytes, count: apduBytes.count);
    }
    
    
    func toString() -> String {
        return self.commandName + ": CLA=" + MifareUtils.toHexString(buffer: self.cla) + ", INS=" + MifareUtils.toHexString(buffer: self.ins) + ", P1=" + MifareUtils.toHexString(buffer: self.p1!) + ", P2=" + MifareUtils.toHexString(buffer: self.p2!) + ", Data=" + MifareUtils.toHexString(buffer: self.data);
    }
}

//class SelectCommand : ApduCommand {
//    init(aid: [UInt8], le: UInt8) {
//        super.init(commandName: "SelectCommand", cla: Cla.CompliantCmd0x, ins: Ins.SelectFile, p1: 0x04, p2: nil, le: le, data: aid);
//    }
//}

class GetDataCommand : ApduCommand {
    var gettDataDataType: ApduEnums.GetDataDataType;
    
    init(commandName: String, gettDataDataType: ApduEnums.GetDataDataType) {
        self.gettDataDataType = gettDataDataType;
        super.init(commandName: commandName, cla: ApduEnums.Cla.ReservedForPts, ins: ApduEnums.Ins.GetData, p1: self.gettDataDataType.rawValue, p2: 0x00, le: 0x00, data: []);
    }
    
    convenience init(gettDataDataType: ApduEnums.GetDataDataType) {
        self.init(commandName: "GetDataCommand", gettDataDataType: gettDataDataType);
    }
}

class GetUidCommand : GetDataCommand {
    init() {
        super.init(commandName: "GetUidCommand", gettDataDataType: ApduEnums.GetDataDataType.Uid);
    }
}

class GetHistoricalBytesCommand : GetDataCommand {
    init() {
        super.init(commandName: "GetHistoricalBytesCommand", gettDataDataType: ApduEnums.GetDataDataType.HistoricalBytes);
    }
}

class GeneralAuthenticateCommand : ApduCommand {
    
    var VersionNumber: UInt8 {
        set(value) {
            self.data[0] = value;
        }
        get {
            return self.data[0];
        }
    }
    
    var KeyType: UInt8 {
        set(value) {
            self.data[3] = value;
        }
        get {
            return self.data[3];
        }
    }
    
    var KeyNumber: UInt8 {
        set(value) {
            self.data[4] = value;
        }
        get {
            return self.data[4];
        }
    }
    
    var Address: UInt16 {
        set(value)
        {
            self.data[1] = UInt8(value >> 8);
            self.data[2] = UInt8(value & 0x00FF);
        }
        get {
            return UInt16((self.data[1] << 8) | self.data[2]);
        }
    }
    
    init(version: ApduEnums.GeneralAuthenticateVersionNumber, address: UInt16, keyType: ApduEnums.GeneralAuthenticateKeyType, keyNo: UInt8) {
        super.init(commandName: "GeneralAuthenticateCommand", cla: ApduEnums.Cla.ReservedForPts, ins: ApduEnums.Ins.GeneralAuthenticate, p1: 0x00, p2: 0x00, le: nil, data: [version.rawValue, UInt8(address >> 8), UInt8(address & 0x00FF), keyType.rawValue, keyNo]);
    }
    
    convenience init(address: UInt16, keySlotNumber: UInt8, keyType: ApduEnums.GeneralAuthenticateKeyType) {
        self.init(version: ApduEnums.GeneralAuthenticateVersionNumber.VersionOne, address: address, keyType: keyType, keyNo: keySlotNumber);
        //        if keyType != GeneralAuthenticateKeyType.MifareKeyA && keyType != GeneralAuthenticateKeyType.PicoTagPassKeyB {
        //            throw new Exception("Invalid key type for MIFARE Standard General Authenticate");
        //        }
    }
}

class LoadKeysCommand : ApduCommand {
    var KeyType: UInt8 {
        set(value) {
            self.p1 = (self.p1! & ~ApduEnums.LoadKeysKeyType.Mask.rawValue) | (value & ApduEnums.LoadKeysKeyType.Mask.rawValue);
        }
        get {
            return self.p1! & ApduEnums.LoadKeysKeyType.Mask.rawValue;
        }
    }
    
    var TransmissionType: UInt8 {
        set (value){
            self.p1 = (self.p1! & ~ApduEnums.LoadKeysTransmissionType.Mask.rawValue) | (value & ApduEnums.LoadKeysTransmissionType.Mask.rawValue);
        }
        get {
            return self.p1! & ApduEnums.LoadKeysTransmissionType.Mask.rawValue;
        }
    }
    
    var StorageType: UInt8 {
        set (value){
            self.p1 = (self.p1! & ~ApduEnums.LoadKeysStorageType.Mask.rawValue) | (value & ApduEnums.LoadKeysStorageType.Mask.rawValue);
        }
        get {
            return self.p1! & ApduEnums.LoadKeysStorageType.Mask.rawValue;
        }
    }
    
    var ReaderKeyNumber: UInt8 {
        set (value){
            self.p1 = (self.p1! & 0xF0) | (value & 0x0F);
        }
        get {
            return (self.p1! & 0x0F);
        }
    }
    
    var KeyNumber: UInt8 {
        set (value){
            self.p2 = value;
        }
        get {
            return self.p2!;
        }
    }
    
    var KeyData: [UInt8] {
        set(value) {
            self.data = value;
        }
        get {
            return self.data;
        }
    }
    
    init(commandName: String, keyType: ApduEnums.LoadKeysKeyType, readerKeyNumber: UInt8, transmissionType: ApduEnums.LoadKeysTransmissionType, storageType: ApduEnums.LoadKeysStorageType, keyNumber: UInt8, keyData: [UInt8]) {
        super.init(commandName: commandName, cla: ApduEnums.Cla.ReservedForPts, ins: ApduEnums.Ins.LoadKeys, p1: (keyType.rawValue | transmissionType.rawValue | storageType.rawValue | readerKeyNumber), p2: keyNumber, le: nil, data: keyData);
    }
    
    convenience init(keyType: ApduEnums.LoadKeysKeyType, readerKeyNumber: UInt8, transmissionType: ApduEnums.LoadKeysTransmissionType, storageType: ApduEnums.LoadKeysStorageType, keyNumber: UInt8, keyData: [UInt8]) {
        self.init(commandName: "LoadKeysCommand", keyType: keyType, readerKeyNumber: readerKeyNumber, transmissionType: transmissionType, storageType: storageType, keyNumber: keyNumber, keyData: keyData);
    }
}

class LoadKeyCommand : LoadKeysCommand {
    // TODO: use runtime detection to do either a non-volatile load on desktop or a volatile load on phone
    // TODO: retest non-volatile load on Win10 Mobile
    init(commandName: String, mifareKey: [UInt8], keySlotNumber: UInt8) {
        super.init(commandName: commandName, keyType: ApduEnums.LoadKeysKeyType.CardKey, readerKeyNumber: 0x00, transmissionType: ApduEnums.LoadKeysTransmissionType.Volatile, storageType: ApduEnums.LoadKeysStorageType.Volatile, keyNumber: keySlotNumber, keyData: mifareKey);
    }
    
    convenience init(mifareKey: [UInt8], keySlotNumber: UInt8) {
        self.init(commandName: "LoadKeyCommand", mifareKey: mifareKey, keySlotNumber: keySlotNumber);
    }
    
    //func GetLoadKeysType() {
    //    #if WINDOWS_APP
    //    return LoadKeysStorageType.NonVolatile;
    //    #elif WINDOWS_UAP
    //    // For phone we need to use Volatile, for desktop NV
    //    if(Windows.Foundation.Metadata.ApiInformation.IsApiContractPresent("Windows.Phone.PhoneContract", 1))
    //    return LoadKeysStorageType.Volatile;
    //
    //    return LoadKeysStorageType.NonVolatile;
    //    #else
    //    return LoadKeysStorageType.Volatile;
    //    #endif
    //}
}

class ReadBinaryCommand : ApduCommand {
    init(commandName: String, address: UInt16, expectedReturnBytes: UInt8?) {
        super.init(commandName: commandName, cla: ApduEnums.Cla.ReservedForPts, ins: ApduEnums.Ins.ReadBinary, p1: 0x00, p2: nil, le: expectedReturnBytes, data: []);
        self.Address = address;
    }
    
    convenience init(address: UInt16, expectedReturnBytes: UInt8?) {
        self.init(commandName: "ReadBinaryCommand",  address: address, expectedReturnBytes: expectedReturnBytes);
    }
    
    var Address: UInt16 {
        set(value) {
            self.p1 = UInt8(value >> 8);
            self.p2 = UInt8(value & 0x00FF);
        }
        get {
            return (UInt16(self.p1!) << 8) | UInt16(self.p2!);
        }
    }
}

class ReadCommand : ReadBinaryCommand {
    init(commandName: String, address: UInt16) {
        super.init(commandName: commandName, address: address, expectedReturnBytes: 16);
    }
    
    convenience init(address: UInt16) {
        self.init(commandName:"ReadCommand", address: address);
    }
}

class UpdateBinaryCommand : ApduCommand {
    init(commandName: String, address: UInt16, dataToWrite: [UInt8]){
        super.init(commandName: commandName, cla: ApduEnums.Cla.ReservedForPts, ins: ApduEnums.Ins.UpdateBinary, p1: 0x00, p2: nil, le: nil, data: dataToWrite);
        self.Address = address;
    }
    
    convenience init(address: UInt16, dataToWrite: [UInt8]){
        self.init(commandName: "UpdateBinaryCommand", address: address, dataToWrite: dataToWrite);
    }
    
    var Address: UInt16 {
        set(value) {
            self.p1 = UInt8(value >> 8);
            self.p2 = UInt8(value & 0x00FF);
        }
        get {
            return (UInt16(self.p1!) << 8) | UInt16(self.p2!);
        }
    }
}

class WriteCommand : UpdateBinaryCommand {
    
    func resizeData(bytes: [UInt8], size: Int) -> Void {
        if self.data.count != size {
            self.data = [];
            for i in 0...size - 1 {
                if i < bytes.count {
                    self.data = self.data + [bytes[i]];
                } else {
                    self.data = self.data + [0x00];
                }
            }
        }
    }
    
    init(commandName: String, address: UInt16, data: [UInt8]) {
        super.init(commandName:commandName, address: address, dataToWrite: data);
        self.resizeData(bytes: data, size: 16);
    }
    
    convenience init(address: UInt16, data: [UInt8]) {
        self.init(commandName: "WriteCommand", address: address, data: data);
    }
}
