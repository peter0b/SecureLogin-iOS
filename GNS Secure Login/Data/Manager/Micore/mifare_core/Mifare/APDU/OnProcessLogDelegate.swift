//
//  OnProcessLogDelegate.swift
//  GNS.SecureLogin
//
//  Created by Paula Mansour on 4/30/19.
//  Copyright © 2019 Paula Mansour. All rights reserved.
//

import Foundation

class OnProcessLogDelegate {
    var useFile: Bool = false;
    
    func log(value: String) {
        do {
            if useFile == true {
//                Log.logger.directory =  FileManager.default.currentDirectoryPath;
//                Log.logger.write(value);
            } else {
                print(value);
            }
        } catch {
        }
    }
    
    func logError(error: Error) {
        log(value: error.localizedDescription);
    }
}

