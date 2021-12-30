//
//  MiFareDesfireHelper.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 29/07/2021.
//

import Foundation
import CryptoTokenKit
import Security
import CommonCrypto
import SmartCardIO


class MiFareDesfireHelper {
    
    
    typealias OnCommandComplete = (ApduResponse?, Error?) -> Void
    typealias OnDataComplete = (Bool, Any?, Error?) -> Void
    
    private var card: Card
    private var mifareNFCCardManager: ApduCommandExecuter;
    
    var nFCSitesDictionary: [String: Int] = [:]
    var siteConfigFileBytes: [UInt8] = []
    var site: SiteVM?
    
    private let aidConfig: [UInt8] = [0x11, 0x11, 0x11]
    private let aidSites1: [UInt8] = [0xAA, 0xAA, 0xAA]
    private let aidSites2: [UInt8] = [0xAB, 0xAB, 0xAB]
    private let aidWinCred: [UInt8] = [0xBB, 0xBB, 0xBB]
    private let configFileSizeId: UInt8 = 0x00
    private let configFileId: UInt8 = 0x01
    private let configFileSize: Int = 10
    private var configFileIDSize: Int = 100
    private let maxSitesCount: UInt8 = 16
    private let sitesFirstFileId: UInt8 = 2
    private let maxSiteFileSize: UInt8 = 40 // in bytes
    private let siteIdSize: UInt8 = 3 // in bytes
    private let appsFileId: UInt8 = 0x03
    private let winCredCount = 8
    private let winCredSize = 80
    
    init(card: Card, mifareNFCCardManager: ApduCommandExecuter) {
        self.card = card
        self.mifareNFCCardManager = mifareNFCCardManager;
    }
    
    private func authenticate(complete: @escaping OnCommandComplete) -> Void {
        self.getAuthenticationChallenge() { (apduResponse, error) in
            if apduResponse != nil && apduResponse!.success {
                do {
                    // Received challenge on the last step
                    let challenge = apduResponse!.responseData;
                    
                    var IV: [UInt8] = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
                    let defaultKey: [UInt8] = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
                    
                    // Decrypt the challenge with default key for a blank DESFire card.
                    // defaultKey = 8 byte array = [0x00, ..., 0x00]
                    //let rndB = self.decrypt(data: challenge, keyData: defaultKey, ivData: IV);
                    
                    guard let rndB = try MifareUtils.decrypte(data: challenge, key: defaultKey, IV: IV) else {
                        print("rndB failed to decrypt")
                        return
                    }
                    
                    // Rotate left the rndB
                    let leftRotatedRndB = MifareUtils.rotateLeft(data: rndB) //rndB.rotateLeft();
                    
                    // Of course the rndA shall be a random number, but we will use a constant number to make the example easier.
                    let rndA: [UInt8] = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
                    
                    IV = challenge;
                    
                    // Concatenate the RndA and rotated RndB
                    // rndA_rndB = 0001020304050607 + 485013d80a0567ea
                    let rndA_rndB = MifareUtils.concatentate(dataA: rndA, dataB: leftRotatedRndB) //rndA + leftRotatedRndB;
                    
                    // Encrypt the bytes of the last step to get the challenge answer
                    let challengeAnswerBytes =  try MifareUtils.encrypt(data: rndA_rndB, key: defaultKey, IV: IV)
                    guard let mChallengeAnswerBytes = challengeAnswerBytes else {
                        print("challengeAnswerBytes empty")
                        return
                    }
                    IV = MifareUtils.copyOfRange(arr: mChallengeAnswerBytes, from: 8, to: 16)!
                    
                    let apduCommand = ApduCommand.init(commandName: "authenticate", cla: ApduEnums.Cla.ProprietaryCla9x, ins: ApduEnums.Ins.ContinueAF, p1: 0x00, p2: 0x00, le: 0x00, data: mChallengeAnswerBytes);
                    self.mifareNFCCardManager.sendAPUDCommand(card: self.card, apduCommand: apduCommand) { (apduResponse, error) in
                        self.mifareNFCCardManager.onProcessLogDelegate.log(value: apduCommand.toString());
                        if apduResponse != nil && apduResponse?.responseData != nil && (apduResponse?.responseData.count ?? 0) > 0 {
                            do {
                                let encryptedRndAFromCard = apduResponse!.responseData;
                                guard let rotatedRndAFromCard = try MifareUtils.decrypte(data: encryptedRndAFromCard, key: defaultKey, IV: IV) else {
                                    print("failed to get rotatedRbdAFromCard")
                                    return
                                }
                                let rndAFromCard = MifareUtils.rotateRight(data: rotatedRndAFromCard) //rotatedRndAFromCard.rotateRight();
                                
                                if rndA.elementsEqual(rndAFromCard, by: { $0 == $1 }) {
                                    self.mifareNFCCardManager.onProcessLogDelegate.log(value: "Authenticated!!!")
                                } else {
                                    self.mifareNFCCardManager.onProcessLogDelegate.log(value: " ### Authentication failed. ### rndA:" + MifareUtils.toHexString(buffer: rndA) + ", rndA from Card: " + MifareUtils.toHexString(buffer: rndAFromCard));
                                }
                            } catch {
                                self.mifareNFCCardManager.onProcessLogDelegate.logError(error: error);
                            }
                        }
                        complete(apduResponse, error);
                    }
                } catch {
                    self.mifareNFCCardManager.onProcessLogDelegate.logError(error: error);
                }
            }
        }
    }
    
    private func getAuthenticationChallenge(complete: @escaping OnCommandComplete) -> Void {
        let apduCommand = ApduCommand.init(commandName: "getAuthenticationChallenge", cla: ApduEnums.Cla.ProprietaryCla9x, ins: ApduEnums.Ins.GetAuthenticationChallenge, p1: 0x00, p2: 0x00, le: 0x00, data: [0x00]);
        self.mifareNFCCardManager.sendAPUDCommand_Single(card: card, apduCommand: apduCommand ){ (apduResponse, error) in
            complete(apduResponse, error);
        }
    }
    
    private func getKeySettings(complete: @escaping OnCommandComplete) -> Void {
        let apduCommand = ApduCommand.init(commandName: "getKeySettings", cla: ApduEnums.Cla.ProprietaryCla9x, ins: ApduEnums.Ins.GetKeySettings, p1: 0x00, p2: 0x00, le: 0x00, data: []);
        self.mifareNFCCardManager.sendAPUDCommand(card: card, apduCommand: apduCommand){ (apduResponse, error) in
            complete(apduResponse, error);
        }
    }
    
    private func getCardUID(complete: @escaping OnCommandComplete) -> Void {
        let apduCommand = ApduCommand.init(commandName: "getCardUID", cla: ApduEnums.Cla.ReservedForPts, ins: ApduEnums.Ins.CreateApplication, p1: 0x00, p2: 0x00, le: 0x00, data: []);
        //        let apduCommand = ApduCommand.init(commandName: "getCardUID", cla: ApduEnums.Cla.ProprietaryCla9x, ins: ApduEnums.Ins.GetCardUID, p1: 0x00, p2: 0x00, le: 0x00, data: []);
        self.mifareNFCCardManager.sendAPUDCommand(card: card, apduCommand: apduCommand){ (apduResponse, error) in
            complete(apduResponse, error);
        }
    }
    
    private func formatPICC(complete: @escaping OnCommandComplete) {
        let apduCommand = ApduCommand.init(commandName: "formatPICC", cla: .ProprietaryCla9x, ins: .FormatPICC, p1: 0x00, p2: 0x00, le: 0x00, data: [])
        self.mifareNFCCardManager.sendAPUDCommand(card: card, apduCommand: apduCommand, complete: complete)
    }
    
    private func createApplication(aid: [UInt8], complete: @escaping OnCommandComplete) {
        var data: [UInt8] = []
        aid.forEach { data.append($0) }
        data.append(0xFF) // keysetting1
        data.append(0x00) // keysetting2
        let apduCommand = ApduCommand.init(commandName: "createApplication", cla: .ProprietaryCla9x, ins: .CreateApplication, p1: 0x00, p2: 0x00, le: 0x00, data: data)
        self.mifareNFCCardManager.sendAPUDCommand(card: card, apduCommand: apduCommand, complete: complete)
    }
    
    private func selectApplication(aid: [UInt8], complete: @escaping OnCommandComplete) -> Void {
        let apduCommand = ApduCommand.init(commandName: "selectApplication", cla: ApduEnums.Cla.ProprietaryCla9x, ins: ApduEnums.Ins.SelectApplication, p1: 0x00, p2: 0x00, le: 0x00, data: aid);
        self.mifareNFCCardManager.sendAPUDCommand(card: card, apduCommand: apduCommand, complete: complete)
    }
    
    private func createFile(fileID: UInt8, file_size: Int, complete: @escaping OnCommandComplete) -> Void {
        let comm_mode: UInt8 = 0x00;
        let access_rights: [UInt8] = [0xEE, 0xEE];
        let fileSizeBytes: [UInt8] = Array(MifareUtils.toByteArray(file_size).prefix(3))
        let data = [fileID] + [comm_mode] + access_rights + fileSizeBytes;
        let apduCommand = ApduCommand.init(commandName: "createFile", cla: ApduEnums.Cla.ProprietaryCla9x, ins: ApduEnums.Ins.CreateFile, p1: 0x00, p2: 0x00, le: 0x00, data: data);
        self.mifareNFCCardManager.sendAPUDCommand(card: card, apduCommand: apduCommand, complete: complete)
    }
    
    private func deleteFile(fileID: UInt8, complete: @escaping OnCommandComplete) -> Void {
        let apduCommand = ApduCommand.init(commandName: "deleteFile", cla: ApduEnums.Cla.ProprietaryCla9x, ins: ApduEnums.Ins.DeleteFile, p1: 0x00, p2: 0x00, le: 0x00, data: [fileID]);
        self.mifareNFCCardManager.sendAPUDCommand(card: card, apduCommand: apduCommand)  { (apduResponse, error) in
            complete(apduResponse, error);
        }
    }
    
    private func getFileIDs(complete: @escaping OnCommandComplete) -> Void {
        let apduCommand = ApduCommand.init(commandName: "getFileIDs", cla: ApduEnums.Cla.ProprietaryCla9x, ins: ApduEnums.Ins.GetFileIDs, p1: 0x00, p2: 0x00, le: 0x00, data: []);
        self.mifareNFCCardManager.sendAPUDCommand(card: card, apduCommand: apduCommand, complete: complete)
    }
    
    private func readData(fileID: UInt8, file_size: Int, complete: @escaping OnCommandComplete) {
        let offsetBytes: [UInt8] = [0x0, 0x00, 0x00]
//        let fileSizeBytes: [UInt8] = Array(MifareUtils.toByteArray(file_size).prefix(3))
        let fileSizeBytes: [UInt8] = Array(MifareUtils.bytes(of: file_size, to: UInt8.self, droppingZeros: false).prefix(3))
        
        let apduCommand = ApduCommand.init(commandName: "readData", cla: ApduEnums.Cla.ProprietaryCla9x, ins: ApduEnums.Ins.ReadData, p1: 0x00, p2: 0x00, le: 0x00, data: [fileID] + offsetBytes + fileSizeBytes);
        self.mifareNFCCardManager.sendAPUDCommand(card: card, apduCommand: apduCommand, complete: complete)
    }
    
    private func readData(fileID: UInt8, file_size: [UInt8], complete: @escaping OnCommandComplete) {
        let offsetBytes: [UInt8] = [0x0, 0x00, 0x00]
        var data: [UInt8] = []
        data.append(fileID)
        data.append(contentsOf: offsetBytes)
        data.append(contentsOf: file_size)
        let apduCommand = ApduCommand.init(commandName: "readData", cla: .ProprietaryCla9x, ins: .ReadData, p1: 0x00, p2: 0x00, le: 0x00, data: data)
        self.mifareNFCCardManager.sendAPUDCommand(card: card, apduCommand: apduCommand, complete: complete)
    }
    
    private func writeData(fileID: UInt8, bytes: [UInt8] , complete: @escaping OnCommandComplete) -> Void {
        let file_size: Int = bytes.count + 4;
        let offsetBytes: [UInt8] = [0x0, 0x00, 0x00]
        let fileSizeBytes: [UInt8] = Array(MifareUtils.toByteArray(file_size).prefix(3))
        let bytesLenInBytes: [UInt8] = Array(MifareUtils.toByteArray(bytes.count).prefix(4))
        let writeBytes = [fileID] + offsetBytes + fileSizeBytes + bytesLenInBytes + bytes;
        
        let apduCommand = ApduCommand.init(commandName: "writeData", cla: ApduEnums.Cla.ProprietaryCla9x, ins: ApduEnums.Ins.WriteData, p1: 0x00, p2: 0x00, le: 0x00, data: writeBytes);
        apduCommand.useFrames = true;
        self.mifareNFCCardManager.sendAPUDCommand(card: card, apduCommand: apduCommand, complete: complete)
    }
    
    func getUid(completion: @escaping OnCommandComplete) {
        authenticate { [weak self] _, aError in
            if let error = aError {
                completion(nil, error)
                return
            }
            self?.getCardUID(complete: completion)
        }
    }
    
    func formatAndReconfigCard(complete: @escaping OnCommandComplete) {
        authenticate { [weak self] _, _ in
            self?.formatPICC(complete: { [weak self] _, _ in
                guard let self = self else { return }
                self.createApplication(aid: self.aidSites1) { _, _ in }
                self.createApplication(aid: self.aidSites2) { _, _ in }
                self.createApplication(aid: self.aidWinCred) { _, _ in }
                self.createApplication(aid: self.aidConfig) { [weak self] createAIDWinCredApduResponse, error in
                    guard let self = self else { return }
                    if createAIDWinCredApduResponse?.success == true {
                        self.selectApplication(aid: self.aidConfig) { [weak self] _, _ in
                            guard let self = self else { return }
                            self.createFile(fileID: self.configFileSizeId, file_size: self.configFileSize) { _, _ in }
                            self.createFile(fileID: self.configFileId, file_size: self.configFileIDSize) { _, _ in
                                complete(createAIDWinCredApduResponse, error)
                            }
                        }
                    } else {
                        complete(createAIDWinCredApduResponse, error)
                    }
                }
            })
        }
    }
    
    func syncSitesDictionaryFromConfigFile(sitesCodes: [String], complete: @escaping OnCommandComplete) {
        
        nFCSitesDictionary = [:]
        siteConfigFileBytes  = []
        
        selectApplication(aid: aidConfig) { [weak self] sares, saerr in
            guard let self = self else { return }
            if let saerr = saerr {
                complete(nil, saerr)
                return
            }
            self.getFileIDs { r, e in
                
            }
            self.readData(fileID: self.configFileId, file_size: self.configFileIDSize) { rres, rerr in
                if let rerr = rerr {
                    complete(nil, rerr)
                    return
                }
                if let rres = rres {
                    if !rres.success {
                        complete(nil, nil)
                        return
                    }
                    print("*****************************************")
                    print("Read response data:", rres.responseData)
                    print("*****************************************")
                    if rres.responseData.allSatisfy({ $0 == 0x00 }) {
                        self.getFreeFilesIdsAndAddNewSites(addedSites: sitesCodes, complete: complete)
                    } else {
                        
                        self.readData(fileID: self.configFileId, file_size: self.configFileSize) { response, error in
                            if response?.success == false {
                                complete(response, error)
                                return
                            }
                            let configContent = self.getConfigFileContent(responseData: response!.responseData)
                            self.siteConfigFileBytes = response!.responseData
                            let sitesArr = configContent.split(separator: "\n").map { String($0) }.filter { !$0.isEmpty }
                            sitesArr.forEach { item in
                                if !self.nFCSitesDictionary.containsKey(key: item) {
                                    let fileIndex = Int(String(item.last!)) ?? 0
                                    let newKey = item.prefix(Int(self.siteIdSize))
                                    self.nFCSitesDictionary[String(newKey)] = fileIndex
                                }
                            }
                            if sitesCodes.isEmpty {
                                complete(response, error)
                                return
                            }
                            
                            let deletedSites = self.nFCSitesDictionary.filter { !sitesCodes.contains($0.key) }
                            //                                let  addedSites = self.nFCSitesDictionary.filter { sitesCodes.contains($0.key) }
                            let addedSites = sitesCodes.filter { !self.nFCSitesDictionary.keys.contains($0) }
                            
                            if !deletedSites.isEmpty {
                                for dItem in deletedSites {
                                    let dicIndexId = UInt8(dItem.value)
                                    let bytePair = self.getAppIdAndFileId(dicIndex: dicIndexId)
                                    self.selectApplication(aid: bytePair.appId) { selectr, selecte in
                                        if selectr?.success == true {
                                            self.deleteFile(fileID: bytePair.fileId) { r, e in
                                                if r?.success == true {
                                                    self.nFCSitesDictionary.removeValue(forKey: dItem.key)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if !addedSites.isEmpty {
                                self.getFreeFilesIdsAndAddNewSites(addedSites: sitesCodes, complete: complete)
                            }
                            
                            complete(response, error)
                            return
                        }
                    }
                } else {
                    complete(rres, rerr)
                }
            }
        }
        
        
        
        
        
        
        //        selectApplication(aid: aidConfig) { [weak self] sr, se in
        //            guard let self = self else { return }
        //            self.readData(fileID: self.configFileId, file_size: self.configFileIDSize) { res, err in
        //                if let error = err {
        //                    complete(nil, error)
        //                    return
        //                }
        //                if let response = res {
        //                    if !response.success {
        //                        complete(nil, nil)
        //                        return
        //                    }
        //                    if response.responseData.allSatisfy({ $0 == 0x00 }) {
        //                        let addedSites = sitesCodes.filter { !self.nFCSitesDictionary.keys.contains($0) }
        //                        self.getFreeFilesIdsAndAddNewSites(addedSites: addedSites, complete: complete)
        //                    } else {
        //                        print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
        //                        self.compareSites(sites: sitesCodes, responseArray: response.responseData)
        //
        //
        ////                            let configFileSize: Int = try MifareUtils.toInt32(bytes: Array(response.responseData.dropFirst(4)), index: 0)
        ////                        self.readData(fileID: self.configFileId, file_size: self.configFileIDSize) { re, er in
        ////                            if !re!.success {
        ////                                complete(re, er)
        ////                                return
        ////                            }
        ////                            print(re!.responseData)
        ////                            let configContent = self.getConfigFileContent(responseData: re!.responseData)
        ////                            self.siteConfigFileBytes = re!.responseData
        ////                            #warning("Is the sitesArr result is right?!!!!")
        ////                            let sitesArr = configContent.split(separator: " ").filter { !$0.isEmpty }
        ////                            print(sitesArr)
        ////                            sitesArr.forEach { item in
        ////                                #warning("Check containsKey func validation (test)")
        ////                                #warning("How could be nfc sites dictionary non-empty here??")
        ////                                if self.nFCSitesDictionary.containsKey(key: String(item)) {
        ////                                    let fileIndex = Int(String(item.last!)) ?? 0
        ////                                    let newKey = String(item).prefix(Int(self.siteIdSize))
        ////                                    self.nFCSitesDictionary[String(newKey)] = fileIndex
        ////                                }
        ////
        ////                                if sitesCodes.count == 0 {
        ////                                    complete(re, er)
        ////                                    return
        ////                                }
        ////
        ////                                let deletedSites = self.nFCSitesDictionary.filter { !sitesCodes.contains($0.key) }
        ////                                if !deletedSites.isEmpty {
        ////                                    for (_, dItem) in deletedSites.enumerated() {
        ////                                        let dicIndexId = UInt8(dItem.value)
        ////                                        let bytePair: ([UInt8], UInt8) = self.getAppIdAndFileId(dicIndex: dicIndexId)
        ////                                        self.selectApplication(aid: bytePair.0) { selectr, selecte in
        ////                                            self.deleteFile(fileID: bytePair.1) { r, e in
        ////                                                if r!.success {
        ////                                                    self.nFCSitesDictionary.removeValue(forKey: dItem.key)
        ////                                                }
        ////                                            }
        ////                                        }
        ////                                    }
        ////                                }
        ////
        ////                                if sitesCodes.isEmpty {
        ////                                    self.getFreeFilesIdsAndAddNewSites(addedSites: sitesCodes, complete: complete)
        ////                                }
        ////                                complete(re, er)
        ////                            }
        ////
        //////                            sitesArr.forEach { item in
        //////                                if self.nFCSitesDictionary[String(item)] != nil {
        //////                                    let fileIndex = Int(String(item.last!)) ?? 0
        //////                                    let newKey = item.prefix(Int(self.siteIdSize))
        //////                                    self.nFCSitesDictionary[String(newKey)] = fileIndex
        //////                                }
        //////                            }
        //////                            if sitesCodes.count == 0 {
        //////                                complete(re, er)
        //////                                return
        //////                            }
        //////                            // A70 , A71 // input
        //////                            // A70 , A80 // exist config file
        //////                            // A70 , A71 new config
        //////                            // get newsites and updatedsites and deleted sites
        //////                            let addedSites = sitesCodes.filter { !self.nFCSitesDictionary.keys.contains($0) }
        //////                            let deletedSites = self.nFCSitesDictionary.filter { !sitesCodes.contains($0.key) }
        //////                            if !deletedSites.isEmpty {
        //////                                for (_, dItem) in deletedSites.enumerated() {
        //////                                    let dicIndexId = UInt8(dItem.value)
        //////                                    let bytePair: ([UInt8], UInt8) = self.getAppIdAndFileId(dicIndex: dicIndexId)
        //////                                    self.selectApplication(aid: bytePair.0) { selectr, selecte in
        //////                                        self.deleteFile(fileID: bytePair.1) { r, e in
        //////                                            if r!.success {
        //////                                                self.nFCSitesDictionary.removeValue(forKey: dItem.key)
        //////                                            }
        //////                                        }
        //////                                    }
        //////                                }
        //////                            }
        //////                            if !addedSites.isEmpty {
        //////                                self.getFreeFilesIdsAndAddNewSites(addedSites: addedSites, complete: complete)
        //////                            }
        //////                            complete(re, er)
        ////                        }
        //                    }
        //                }
        //            }
        //        }
    }
    
    private func getFreeFilesIdsAndAddNewSites(addedSites: [String]?, complete: @escaping OnCommandComplete) {
        var blankIndexes: [UInt8] = []
        let integers = 0..<(maxSitesCount - 1)
        integers.forEach { blankIndexes.append($0) }
        
        fetchFilesIdsFromApplication(aids: aidSites1) { [weak self] fetchRes, data, error in
            guard let self = self else { return }
            if fetchRes && data != nil, let foundedIds = data as? [UInt8?] {
                blankIndexes = blankIndexes.filter { !foundedIds.contains($0) }
                self.addNewSitesToIndexer(addedSites: addedSites, complete: complete, blankIndexes: blankIndexes)
            }
            
            
//            if fetchRes && data != nil {
//                if let foundedIds = data as? [UInt8?] {
//                    blankIndexes = blankIndexes.filter { !foundedIds.contains($0) }
//                    if blankIndexes.count == 16 {
//                        self.fetchFilesIdsFromApplication(aids: self.aidSites2) { r2, data2, error2 in
//                            if r2 && data2 != nil {
//                                if let foundedIds2 = data as? [UInt8] {
//                                    let map = foundedIds2.map { $0 + 16 }
//                                    blankIndexes = blankIndexes.filter { !map.contains($0) }
//                                }
//                                self.addNewSitesToIndexer(addedSites: addedSites, complete: complete, blankIndexes: blankIndexes)
//                            }
//                        }
//                    } else {
//                        self.addNewSitesToIndexer(addedSites: addedSites, complete: complete, blankIndexes: blankIndexes)
//                    }
//                }
//            }
        }
    }
    
    private func fetchFilesIdsFromApplication(aids: [UInt8], complete: @escaping OnDataComplete) {
        selectApplication(aid: aids) { [weak self] _, se in
            self?.getFileIDs(complete: { res, err in
                complete(res?.success ?? false, res?.responseData, err)
            })
            complete(false, nil, se)
        }
    }
    
    private func addNewSitesToIndexer(addedSites: [String]?, complete: @escaping OnCommandComplete, blankIndexes: [UInt8]) {
        var blankIndexes = blankIndexes
        addedSites!.forEach { siteCode in
            if blankIndexes.count == 0 {
                complete(ApduResponse(commandName: "Create New File Error", responseData: [], success: false), ApduError.cardSizeFull)
                return
            }
            let blanckDicIndex = blankIndexes.first
            let bytePair = getAppIdAndFileId(dicIndex: blanckDicIndex!)
            let appId = bytePair.appId
            let fileId = bytePair.fileId
            selectApplication(aid: appId) { [weak self] sr, se in
                guard let self = self else { return }
                self.createFile(fileID: fileId, file_size: Int(self.maxSiteFileSize)) { resss, errr in
                    if let errr = errr {
                        dump(errr)
                        return
                    }
                    dump(resss!)
                }
                if self.nFCSitesDictionary[siteCode] == nil {
                    self.nFCSitesDictionary[siteCode] = Int(blanckDicIndex!)
                }
                blankIndexes.remove(object: blanckDicIndex!)
            }
        }
        updateNfcConfigFile(sitesDictionary: nFCSitesDictionary) { ur, ue in
            complete(ur, ue)
        }
    }
    
    private func getAppIdAndFileId(dicIndex: UInt8) -> (appId: [UInt8], fileId: UInt8) {
        return (getAppIdFromDicIndex(dicIndex: dicIndex), getFileIdFromDicIndex(dicIndex: dicIndex))
    }
    
    private func getAppIdFromDicIndex(dicIndex: UInt8) -> [UInt8] {
        return dicIndex > 15 ? aidSites2 : aidSites1
    }
    
    private func getFileIdFromDicIndex(dicIndex: UInt8) -> UInt8 {
        return dicIndex < 16 ? dicIndex : (dicIndex - 16)
    }
    
    private func updateNfcConfigFile(sitesDictionary: [String: Int], complete: @escaping OnCommandComplete) {
        selectApplication(aid: aidConfig) { [weak self] _, _ in
            guard let self = self else { return }
            self.deleteFile(fileID: self.configFileId) { _, _ in
                let bytesToWrite = self.getSitesDictionaryBytes(sitesDictionary: sitesDictionary)
//                self.configFileIDSize = (bytesToWrite?.count ?? 0) + 8
                self.createFile(fileID: self.configFileId, file_size: (bytesToWrite?.count ?? 0) + 8) { cr, ce in
                    if cr?.success == true {
                        self.writeData(fileID: self.configFileId, bytes: bytesToWrite!) { wr, we in
//                            complete(wr, we)
                            if wr?.success == true {
//                                let sizeBytes = MifareUtils.toByteArray((bytesToWrite!.count + 8))
                                let sizeBytes = MifareUtils.bytes(of: (bytesToWrite!.count + 8), to: UInt8.self, droppingZeros: true)
                                self.writeData(fileID: self.configFileSizeId, bytes: sizeBytes) { _, _ in }
                                complete(wr, we)
                            }
                        }
                    } else {
                        complete(cr, ce)
                    }
                }
            }
        }
    }
    
    private func getSitesDictionaryBytes(sitesDictionary: [String: Int]) -> [UInt8]? {
        var blocks = ""
        for key in Array(sitesDictionary.keys) {
            if let value = sitesDictionary[key] {
                var n = "\(key)"
                n.append("\(MifareUtils.toHexString(buffer: value))")
                n.append("\n")
                blocks.append(n)
            }
        }
        return MifareUtils.hexToByteArray(hexString: blocks)
    }
    
    private func getConfigFileContent(responseData: [UInt8]) -> String {
        if responseData.isEmpty { return "" }
        let lastValidBytesIndex = (responseData.lastIndex(where: { $0 == 0x0a }) ?? 0) // 0x0a is \n
        let dataBytes = Array(responseData.prefix(lastValidBytesIndex + 1).dropFirst(4)) // skip system 4 bytes
        return MifareUtils.toString(bytes: dataBytes)
    }
    
    func readSitesFromCard(cardChannel: Card, sites: [SiteVM], complete: @escaping OnCommandComplete) {
        self.card = cardChannel
        if self.nFCSitesDictionary.isEmpty {
            complete(nil, ApduError.noSites)
            return
        }
        // read fileIds(01, 02, .. ,15) from first application
        let app1SitesCodes = self.nFCSitesDictionary.filter { $0.value < 16 }.map { $0.key }
        if !app1SitesCodes.isEmpty {
            self.getSitesFromItsApplication(aid: self.aidSites1, sites: sites, sitesCodes: app1SitesCodes)
        }
        // read fileIds(16, 17, .. ,33) from second application
        let app2SitesCodes = self.nFCSitesDictionary.filter { $0.value >= 16 }.map { $0.key }
        if !app2SitesCodes.isEmpty {
            self.getSitesFromItsApplication(aid: self.aidSites2, sites: sites, sitesCodes: app2SitesCodes)
        }
        complete(ApduResponse(commandName: "", responseData: [], success: true), nil)
    }
    
    private func getSitesFromItsApplication(aid: [UInt8], sites: [SiteVM], sitesCodes: [String]) {
        selectApplication(aid: aid) { sapduResponse, _ in
            if sapduResponse!.success {
//                for site in sites {
                var site: SiteVM? = nil
                if sites.isEmpty {
                    site = nil
                } else if sites.count == 1 {
                    site = sites[0]
                }
                
                if site != nil {
                    let fileIndex = self.nFCSitesDictionary[sites[0].code ?? ""]!
                    self.readSiteCredentialAndSetToObject(site: site, siteCode: sites[0].code!, fileIndex: fileIndex)
                }
//                }
            }
        }
    }
    
    private func readSiteCredentialAndSetToObject(site: SiteVM?, siteCode: String, fileIndex: Int) {
        self.site = site
        if site == nil {
            self.site = SiteVM()
            self.site?.code = siteCode
        }
        let fIndx = UInt8(fileIndex % 16)
        readData(fileID: fIndx, file_size: Int(maxSiteFileSize)) { response, _ in
            if response!.success {
                if response!.responseData.allSatisfy({ $0 == 0x00 }) {
                    self.site?.username = ""
                    self.site?.password = ""
                } else {
                    let responseData = Array(response!.responseData.dropFirst(4)).filter { $0 != 0 }
                    print("responseData:", responseData)
                    let responseString: [String] = MifareUtils.toString(bytes: responseData).split(separator: "\n").map { String($0) }
                    self.site?.username = !responseString.isEmpty ? responseString[0] : ""
                    self.site?.password = !responseString.isEmpty ? responseString[1] : ""
                }
            } else {
                self.site?.username = ""
                self.site?.password = ""
            }
        }
    }
    
    func writeSitesToCard(_ card: Card, sites: [SiteVM], complete: @escaping OnCommandComplete) {
        self.card = card
        if sites.isEmpty {
            complete(nil, ApduError.noSites)
            return
        }
        if nFCSitesDictionary.isEmpty {
            syncSitesDictionaryFromConfigFile(sitesCodes: []) { r, e in
                self.updateSitesToNFCCard(sitesVM: sites, complete: complete)
            }
        } else {
            self.updateSitesToNFCCard(sitesVM: sites, complete: complete)
        }
    }
    
    func updateSitesToNFCCard(sitesVM: [SiteVM], complete: @escaping OnCommandComplete) {
        for site in sitesVM {
            var siteIdStr = site.code
            if siteIdStr!.count > Int(siteIdSize) {
                complete(nil, fatalError("Site Id: ${\(site.code ?? "")} exceeded maximum site Id bytes allowed(${siteIdSize} bytes)"))
            } else if siteIdStr!.count < siteIdSize {
                siteIdStr = fillLeftWithChar(str: siteIdStr ?? "", schar: "0", maxLength: Int(siteIdSize))
            }
            
            let siteDataStr = "\(site.username ?? "")\n\(site.password ?? "")"
            // record represent site data as SiteID 4 bytes (XXXX)
            // and SiteIndex 2 bytes (YY)
            let siteDataBytes = siteDataStr.bytes
            if siteDataBytes.count > Int(maxSiteFileSize) {
                complete(nil, fatalError("Site Size Too Long , allowed only \(maxSiteFileSize) while Current Site Size is \(siteDataBytes.count)"))
            }
            
            let _fileIdInt = nFCSitesDictionary[siteIdStr!]!
            let appId = _fileIdInt < 16 ? aidSites1 : aidSites2
            let _fileId = UInt8(_fileIdInt % 16)
            
            selectApplication(aid: appId, complete: { [unowned self] _, _ in
                self.writeData(fileID: _fileId, bytes: siteDataBytes) { [unowned self] writeR, witeE in
                    if !writeR!.success { // 240 mean's FILE_NOT_FOUND
                        // Create file and write data
                        self.createFile(fileID: _fileId, file_size: Int(self.maxSiteFileSize), complete: { [unowned self] _, _ in
                            self.writeData(fileID: _fileId, bytes: siteDataBytes) { [unowned self] _, _ in
                                self.site?.writeDone = true
                            }
                        })
                    } else {
                        site.writeDone = true
                    }
                }
            })
        }
        complete(ApduResponse(commandName: "All Done", responseData: [], success: true), nil)
    }
    
    private func fillLeftWithChar(str: String, schar: String, maxLength: Int) -> String {
        var s1 = str
        repeat {
            s1.insert(Character(schar), at: s1.startIndex)
        } while str.count < maxLength
        return s1
    }
    
    
    
    private func getVersion_Recursion(ins: ApduEnums.Ins, complete: @escaping OnCommandComplete) -> Void {
        let apduCommand = ApduCommand.init(commandName: "getVersion", cla: ApduEnums.Cla.ProprietaryCla9x, ins: ins, p1: 0x00, p2: 0x00, le: 0x00, data: []);
        self.mifareNFCCardManager.sendAPUDCommand(card: card, apduCommand: apduCommand){ (apduResponse, error) in
            if apduResponse != nil {
                complete(apduResponse, error);
            } else {
                complete(apduResponse, error);
            }
        }
    }
    
    private func listApplications(complete: @escaping OnCommandComplete) -> Void {
        let apduCommand = ApduCommand.init(commandName: "listApplications", cla: .ProprietaryCla9x, ins: .ListApplications, p1: 0x00, p2: 0x00, le: 0x00, data: [])
        self.mifareNFCCardManager.sendAPUDCommand(card: card, apduCommand: apduCommand){ (apduResponse, error) in
            complete(apduResponse, error);
        }
    }
    
    private func getVersion(complete: @escaping OnCommandComplete) -> Void {
        getVersion_Recursion(ins: ApduEnums.Ins.GetVersion, complete: complete);
    }
    
    private func deleteApplication(aid: [UInt8], complete: @escaping OnCommandComplete) {
        let apduCommand = ApduCommand.init(commandName: "deleteApplications", cla: .ProprietaryCla9x, ins: .DeleteApplication, p1: 0x00, p2: 0x00, data: aid)
        self.mifareNFCCardManager.sendAPUDCommand(card: card, apduCommand: apduCommand, complete: complete)
    }
    
    func cardUID(complete: @escaping OnCommandComplete) {
        self.mifareNFCCardManager.getCardInfo(card: card, complete: complete)
    }
    
    func readConfigFile(complete: @escaping OnCommandComplete) {
        print("****************************************************************************************")
        self.selectApplication(aid: self.aidConfig) { selectAppResponse, selectAppError in
            if let selectAppError = selectAppError {
                print("Failed to select aid config app:", selectAppError)
                return
            }
            self.readData(fileID: self.configFileId, file_size: self.configFileSize) { readResponse, readError in
                if let readError = readError {
                    print("Failed to read config file:", readError)
                    return
                }
                
                print("\n Sites data:", readResponse?.responseData)
//                print("Sites hexString:", MifareUtils.toHexString(data: readResponse!.responseData))
                print("readResponse data count:", readResponse?.responseData.count)
                print("Sites:", MifareUtils.toString(bytes: readResponse!.responseData))
                
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.selectApplication(aid: self.aidSites1) { _, _ in
                    
                    
                    self.deleteFile(fileID: 0x09) { _, _ in
                        self.createFile(fileID: 0x09, file_size: Int(self.maxSiteFileSize)) { _, _ in
                            let siteDataStr = MifareUtils.toByteArray("test\npassword09\n")
                            self.writeData(fileID: 0x09, bytes: siteDataStr) { _, _ in
                                
                            }
                            
                            self.readData(fileID: 0x09, file_size: Int(self.maxSiteFileSize)) { readData, _ in
                                print(readData?.responseData)
                            }
                        }
                    }
                }
                //                }
            }
        }
    }

}

enum ApduError: String, Error {
    case cardSizeFull = "Card Size Is Full"
    case noSites = "No Sites Found"
    case siteSizeExceeds = "Site exceeded maximum site Id bytes allowed"
    case largeSiteDataSize = "Site Size Too Long allowed only $maxSiteFileSize while Current Site Size is ${siteDataStr.size}"
}

class SiteVM {
    var code: String? = nil
    var username: String? = nil
    var password: String? = nil
    var writeDone = false
    
    init(code: String? = nil, username: String? = nil, password: String? = nil, writeDone: Bool = false) {
        self.code = code
        self.username = username
        self.password = password
        self.writeDone = writeDone
    }
}
