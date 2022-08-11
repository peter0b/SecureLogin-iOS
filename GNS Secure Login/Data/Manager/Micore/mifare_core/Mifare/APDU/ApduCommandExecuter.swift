//
//  ApduCommandExecuter.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 29/07/2021.
//

import Foundation
import CryptoTokenKit
import SmartCardIO
import ACSSmartCardIO

class ApduCommandExecuter {
    
    internal var onProcessLogDelegate: OnProcessLogDelegate! = OnProcessLogDelegate();
    
    internal func sendAPUDCommand(card: Card, apduCommand: ApduCommand, complete: @escaping (ApduResponse?, Error?) -> Void) -> Void {
        self.sendAPUDCommand_Recursion(card: card, apduCommand: apduCommand, responseData: []){ (apduResponse, error) in
            complete(apduResponse, error);
        }
    }
    
    private func sendAPUDCommand_Recursion(card: Card, apduCommand: ApduCommand, responseData: [UInt8], complete: @escaping (ApduResponse?, Error?) -> Void) -> Void {
        self.sendAPUDCommand_Single(card: card, apduCommand: apduCommand){ (apduResponse, error) in
            if apduResponse != nil {
                if apduResponse!.sw1 == 0x91 && apduResponse!.sw2 == ApduEnums.Ins.ContinueAF.rawValue {
                    let afResponseData = responseData + apduResponse!.responseData;
                    
                    var nextCommand: ApduCommand;
                    if apduCommand.useFrames {
                        nextCommand = apduCommand;
                        nextCommand.ins = ApduEnums.Ins.ContinueAF.rawValue;
                    } else {
                        nextCommand = ApduCommand.init(commandName: apduCommand.commandName, cla: ApduEnums.Cla.ProprietaryCla9x, ins: ApduEnums.Ins.ContinueAF, p1: 0x00, p2: 0x00, le: 0x00, data: []);
                    }
                    
                    self.sendAPUDCommand_Recursion(card: card, apduCommand: nextCommand, responseData: afResponseData, complete: complete);
                } else {
                    if apduCommand.useFrames != true {
                        apduResponse!.responseData = responseData + apduResponse!.responseData;
                    }
                    complete(apduResponse, error);
                }
            } else {
                complete(apduResponse, error);
            }
        }
    }
    
    internal func sendAPUDCommand_Single(card: Card, apduCommand: ApduCommand, complete: @escaping (ApduResponse?, Error?) -> Void) -> Void {
        var data: Data! = nil
        if apduCommand.useFrames == true {
            data = apduCommand.getDataFrame();
        } else {
            data = apduCommand.getData();
        }
        if data != nil && data.count > 0 {
            do {
                let channel = try card.basicChannel()
                let commandAPDU = try CommandAPDU(apdu: data)
                let respone = try channel.transmit(apdu: commandAPDU)
                let apduResponse = ApduResponse(commandName: apduCommand.commandName, response: Data(respone.bytes))
                print(apduResponse.toString())
                complete(apduResponse, nil)
            } catch let error {
                complete(nil, error)
            }
        }
        
//        if self.scard != nil && self.scard.isValid {
            //self.onProcessLogDelegate.log(value: apduCommand.toString());
//            self.onProcessLogDelegate.log(value: "req: " + MifareUtils.toHexString(data: data) + " len: " + String(data.count));
            //print(Convert.toHexa(data: data));
//            self.scard.transmit(data) { (resultData, error) in
//                self.onProcessLogDelegate.log(value: "res: " + MifareUtils.toHexString(data: resultData!));
//                if error != nil {
//                    self.onProcessLogDelegate.log(value:"sendIns error: \(String(describing: error))");
//                    complete(nil, error);
//                } else if resultData != nil {
//                    //print(Convert.toHexa(bytes: resultData!.bytes))
//                    let apduResponse = ApduResponse.init(commandName: apduCommand.commandName, response: resultData!);
//                    if apduResponse.success != true {
//                        self.onProcessLogDelegate.log(value: apduResponse.toString());
//                    }
//                    //let str = apduResponse.toString();
//                    //self.onProcessLogDelegate.log(value: str);
//                    complete(apduResponse, error);
//                }
//            }
//        }
    }
    
    //ex: GetUid: ApduCommand CLA=FF, INS=CA, P1=00, P2=00
    internal func getCardInfo(card: Card, complete: @escaping (ApduResponse?, Error?) -> Void) -> Void {
        self.sendAPUDCommand(card: card, apduCommand: GetUidCommand(), complete: complete)
    }
}
