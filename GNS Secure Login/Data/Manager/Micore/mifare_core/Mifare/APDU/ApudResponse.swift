//
//  ApduResponse.swift
//  GNS.SecureLogin
//
//  Created by Paula Mansour on 5/2/19.
//  Copyright © 2019 Paula Mansour. All rights reserved.
//

import Foundation

class ApduResponse {
    
    var success: Bool = false;
    var responseData: [UInt8] = [];
    var sw1: UInt8 = 0x00;
    var sw2: UInt8 = 0x00;
    var sw: UInt16 = 0x0000;
    var commandName: String = "";
    
    init(commandName: String, responseData: [UInt8], success: Bool) {
        self.responseData = responseData;
        self.success = success;
        self.commandName = commandName;
    }

    init(commandName: String, response: Data?) {
        self.commandName = commandName;
        if response != nil && response!.count > 1 {
            var index: Int = 0;
            let sw1Index: Int = response!.count - 2;
            let sw2Index: Int = response!.count - 1;
            
            for byte in response! {
                if index == sw1Index {
                    sw1 = byte;
                } else if index == sw2Index {
                    sw2 = byte;
                } else {
                    responseData.append(byte);
                }
                index += 1;
            }
            sw = UInt16(sw1) << 8 | UInt16(sw2);
            success = sw == 0x9000 || sw == 0x9100 || sw == 0x91AF;
        }
    }
    
    func status() -> String {
        if sw == 0x9000 || sw == 0x9100 {
            return "Success";
        } else if sw == 0x6700 {
            return "Wrong length (Lc or Le)";
        } else if sw == 0x91AE {
            return "Authentication error";
        } else if sw == 0x6800 {
            return "The requested function is not supported by the card";
        }  else if sw == 0x6A81 {
            return "Function not supported";
        } else if sw == 0x6B00 {
            return "Wrong parameter (P1 or P2)";
        } else if sw == 0x6F00 {
            return "Operation failed";
        } else if sw == 0x91AF {
            return "GetAnotherFrame";
        } else if sw == 0x917E {
            return "LENGTH_ERROR"
        } else {
            return "Unknown!";
        }
    }
    
    func toString() -> String {
        let data  = Data.init(bytes: responseData, count: responseData.count);
        return status() + " command=" + commandName + " SW1=" + MifareUtils.toHexString(buffer: self.sw1) + " SW2=" + MifareUtils.toHexString(buffer: self.sw2) + " Data: " + MifareUtils.toHexString(data: data)
    }
}
